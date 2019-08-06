//
//  APIClient.swift
//  PersistenceProject
//
//  Created by Ben Manning on 29/06/2019.
//  Copyright © 2019 Ben Manning. All rights reserved.
//

import UIKit

class APIClient {
  enum SendError: Error {
    case noData
    case invalidUrl
    case sessionError(error: Error)
    case parseError(error: Error)
  }
  
  typealias SendResult<Response: Decodable> = Result<Response, SendError>
  
  private let host = "jsonplaceholder.typicode.com"
  
  private let session: URLSession
  
  private var tasks = Set<URLSessionDataTask>()
  
  private let taskModifierQueue = DispatchQueue(
    label: "TaskArrayModifier",
    qos: .default,
    attributes: [])
  
  init() {
    let config = URLSessionConfiguration.ephemeral
    config.httpShouldSetCookies = false
    config.httpCookieAcceptPolicy = .never
    
    session = URLSession.init(configuration: config)
  }
  
  func send<Request: APIRequest>(
    request: Request,
    callback: @escaping (SendResult<Request.Response>) -> Void) {
    
    var urlComponents = URLComponents()
    urlComponents.scheme = "https"
    urlComponents.host = host
    urlComponents.path = request.path
    if request.getParams.count > 0 {
      urlComponents.queryItems = request.getParams.map { URLQueryItem(name: $0.key, value: $0.value) }
    }
    
    guard let url = urlComponents.url else {
      callback(.failure(.invalidUrl))
      return
    }
    
    let urlRequest = NSMutableURLRequest(url: url)
    urlRequest.httpMethod = request.method
    
    var removeTask: (() -> Void)?
    
    let task = session.dataTask(with: urlRequest as URLRequest) { (sessionData, _, sessionErr) in
      removeTask?()
      
      let result: SendResult<Request.Response> = self.decodeResponse(
        data: sessionData,
        error: sessionErr,
        apiDecoder: request.decoder)
      
      callback(result)
    }
    
    removeTask = {
      self.removeTask(task: task)
    }
    
    task.resume()
    
    addTask(task: task)
  }
  
  private func decodeResponse<Response>(
    data: Data?,
    error: Error?,
    apiDecoder: APIResponseDecoder) -> SendResult<Response> {
    
    if let error = error {
      return .failure(.sessionError(error: error))
      
    } else if let data = data {
      
      do {
        return .success(try apiDecoder.decode(data: data))
      } catch {
        Logger.w("Error decoding API response \(String(describing: Response.self)) - \(error)")
        return .failure(.parseError(error: error))
      }
    }
    
    return .failure(.noData)
    
  }
  
  private func addTask(task: URLSessionDataTask) {
    taskModifierQueue.sync {
      _ = tasks.insert(task)
    }
  }
  
  private func removeTask(task: URLSessionDataTask) {
    taskModifierQueue.sync {
      _ = tasks.remove(task)
    }
  }
  
  func cancelAllRequests() {
    taskModifierQueue.sync {
      for task in tasks {
        task.cancel()
      }
      
      tasks.removeAll()
    }
  }
}

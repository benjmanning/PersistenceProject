//
//  APIRequest.swift
//  PersistenceProject
//
//  Created by Ben Manning on 29/06/2019.
//  Copyright © 2019 Ben Manning. All rights reserved.
//

import UIKit

protocol APIRequest: Encodable {
  associatedtype Response: Decodable
  
  var path: String { get }
  var getParams: [String: String] { get }
  var method: String { get }
  var decoder: APIResponseDecoder { get }
}

extension APIRequest {
  var getParams: [String: String] { return [:] }
  var method: String { return "GET" }
  var decoder: APIResponseDecoder { return JsonDecoder() }
}

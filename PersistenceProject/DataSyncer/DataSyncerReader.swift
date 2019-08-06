//
//  DataSyncerReader.swift
//  PersistenceProject
//
//  Created by Ben Manning on 31/07/2019.
//  Copyright © 2019 Ben Manning. All rights reserved.
//

import UIKit

class DataSyncerReader {
  struct DataForSync<Dto: DataSyncableDto, ModelObj: DataSyncableModelObj> where Dto.Store == ModelObj.Store {
    let dtos: [Dto]
    let modelObjs: [ModelObj]
    let store: Dto.Store
  }
  
  private let apiClient: APIClient
  private let userStore: UserStore
  private let postStore: PostStore
  private let commentStore: CommentStore

  init(apiClient: APIClient, userStore: UserStore, postStore: PostStore, commentStore: CommentStore) {
    self.apiClient = apiClient
    self.userStore = userStore
    self.postStore  = postStore
    self.commentStore = commentStore
  }
  
  func readDataForComments(
    forPostId postId: Int64,
    callback: (DataForSync<CommentDTO, Comment>) -> Void) {
    
    var commentsResponse: CommentsRequest.Response?
    let dispatchGroup = DispatchGroup()

    getNetworkData(request: CommentsRequest(postId: postId), dispatchGroup: dispatchGroup) { response in
      commentsResponse = response
    }
    
    dispatchGroup.wait()

    if let commentsResponse = commentsResponse {
      let comments = commentStore.get(forPostId: postId) as [Comment]
      callback(DataForSync(dtos: commentsResponse, modelObjs: comments, store: commentStore))
    }
  }
  
  func readDataForPostsWithUsers(
    callback: (DataForSync<PostDTO, Post>, DataForSync<UserDTO, User>) -> Void) -> Bool {
    
    var postsResponse: PostsRequest.Response?
    var usersResponse: UsersRequest.Response?
    let dispatchGroup = DispatchGroup()
    
    getNetworkData(request: PostsRequest(), dispatchGroup: dispatchGroup) { response in
      postsResponse = response
    }
    getNetworkData(request: UsersRequest(), dispatchGroup: dispatchGroup) { response in
      usersResponse = response
    }
    
    dispatchGroup.wait()
    
    if let postsResponse = postsResponse,
      let usersResponse = usersResponse {
      
      let posts = postStore.getAll() as [Post]
      let users = userStore.getAll()
      callback(
        DataForSync(dtos: postsResponse, modelObjs: posts, store: postStore),
        DataForSync(dtos: usersResponse, modelObjs: users, store: userStore))
      
      return true
    }
    
    return false
  }
  
  private func getNetworkData<Request: APIRequest>(
    request: Request,
    dispatchGroup: DispatchGroup,
    dataCallback: @escaping (Request.Response) -> Void) {
    
    dispatchGroup.enter()
    apiClient.send(request: request) { (result) in
      do {
        dataCallback(try result.get())
      } catch {
        Logger.e("Error downloading \(request) - \(error)")
      }
      dispatchGroup.leave()
    }
  }
}

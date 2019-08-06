//
//  PostDetailViewModel.swift
//  PersistenceProject
//
//  Created by Ben Manning on 07/07/2019.
//  Copyright © 2019 Ben Manning. All rights reserved.
//

import UIKit

class PostDetailViewModel: ObservableObjDelegate {
  
  typealias ViewModelObserver = () -> Void
  
  private let observable: ObservableObj<Post>
  
  var title: String = ""
  var body: String = ""
  var author: String = ""
  var email: String = ""
  var commentCount: String = ""
  
  var viewDataObserver: ViewModelObserver? {
    didSet {
      viewDataObserver?()
    }
  }
  
  var deleteObsever: ViewModelObserver?
  
  init(repository: PostRepository, postId: Int64) {
    self.observable = repository.getWithComments(id: postId)
    self.observable.delegate = self
    evaluate()
  }
  
  func observableObjUpdate() {
    evaluate()
  }
  
  func observableObjDelete() {
    deleteObsever?()
  }
  
  func evaluate() {
    title = observable.result?.title ?? ""
    body = observable.result?.body ?? ""
    author = observable.result?.user?.name ?? ""
    email = observable.result?.user?.email ?? ""
    
    let numComments = observable.result?.comments.count ?? 0
    commentCount = "(\(numComments) comment\(numComments == 1 ? "" : "s"))"
    
    viewDataObserver?()
  }
}

//
//  PostListViewController.swift
//  PersistenceProject
//
//  Created by Ben Manning on 22/06/2019.
//  Copyright © 2019 Ben Manning. All rights reserved.
//

import UIKit
import CoreData

class PostListViewController: StoryboardlessViewController {
  
  @IBOutlet var tableView: UITableView!
  
  private var viewModel: PostListViewModel
  private var syncer: DataSyncer
  private var postDetailViewControllerFactory: (Int64) -> PostDetailViewController
  
  private let refreshControl = UIRefreshControl()
  
  init(postListViewModel: PostListViewModel, syncer: DataSyncer, postDetailViewControllerFactory: @escaping (Int64) -> PostDetailViewController) {
    viewModel = postListViewModel
    self.syncer = syncer
    self.postDetailViewControllerFactory = postDetailViewControllerFactory
    
    super.init(nibName: "PostList")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.title = "Posts"
    
    let nib = UINib(nibName: "PostListItemCell", bundle: Bundle.main)
    tableView.register(nib, forCellReuseIdentifier: PostListItemCell.reuseIdentifier)
    
    tableView.refreshControl = refreshControl
    refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
    
    viewModel.fetchedResultsObserverDelegate = self.tableView
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    if let selectedRow = tableView.indexPathForSelectedRow {
      tableView.deselectRow(at: selectedRow, animated: false)
    }
  }
  
  func showPostDetail(post: Post) {
    let postDetailViewController = postDetailViewControllerFactory(post.id)
    navigationController?.pushViewController(postDetailViewController,
                                             animated: true)
  }
  
  @objc func refresh(_ sender: Any) {
    
    syncer.refreshPostsWithUsersAsync { success in
      DispatchQueue.main.async {
        self.refreshControl.endRefreshing()
        
        if !success {
          // An alert view will prevent the tableview from returning after pulldown so do this manually
          self.tableView.setContentOffset(.zero, animated: true)
          
          let alert = UIAlertController(title: "Download",
                                        message: "Unable to download posts at this time, please try again later or contact your provider.",
                                        preferredStyle: .alert)
          
          alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
          
          self.present(alert, animated: true, completion: nil)
        }
      }
    }
  }
}

// MARK: - UITableViewDataSource
extension PostListViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.posts.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: PostListItemCell.reuseIdentifier, for: indexPath)
    let post = viewModel.posts[indexPath.row]
    
    if let cell = cell as? PostListItemCell {
      let viewModel = PostListItemViewModel(post: post)
      cell.setData(viewModel: viewModel)
    }
    
    return cell
  }
  
}

// MARK: - UITableViewDelegate
extension PostListViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let post = viewModel.posts[indexPath.row]
    showPostDetail(post: post)
  }
}

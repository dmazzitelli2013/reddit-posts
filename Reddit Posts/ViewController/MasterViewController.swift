//
//  MasterViewController.swift
//  Reddit Posts
//
//  Created by David Mazzitelli on 12/8/19.
//  Copyright © 2019 David Mazzitelli. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var viewModel: RedditPostsViewModel = RedditPostsViewModel()
            
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Reddit Posts"

        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
                
        tableView.register(UINib(nibName: RedditPostTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: RedditPostTableViewCell.identifier)
        
        refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
    
        viewModel.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }
    
    @objc private func refreshData() {
        viewModel.resetPosts()
        viewModel.fetchMorePosts()
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let post = viewModel.visiblePosts[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = post
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
                detailViewController = controller
            }
        }
    }

}

// MARK: - Table View

extension MasterViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.canFetchMorePosts() {
            return viewModel.visiblePosts.count + 1
        }
        
        return viewModel.visiblePosts.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> RedditPostTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RedditPostTableViewCell.identifier, for: indexPath) as! RedditPostTableViewCell
        
        if indexPath.row < viewModel.visiblePosts.count {
            cell.post = viewModel.visiblePosts[indexPath.row]
        } else {
            cell.post = nil
            if viewModel.canFetchMorePosts() {
                viewModel.fetchMorePosts()
            }
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.removeVisiblePost(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetail", sender: nil)
    }
    
    private func insertNewRows(newIndexes: [Int]) {
        var indexPaths: [IndexPath] = []
        for index in newIndexes {
            indexPaths.append(IndexPath(row: index, section: 0))
        }
        
        tableView.beginUpdates()
        
        if !viewModel.canFetchMorePosts() {
            if let indexPath = tableView.indexPathsForVisibleRows?.last {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }        
        
        tableView.insertRows(at: indexPaths, with: .left)
        
        tableView.endUpdates()
    }
    
}

// MARK: - RedditPosts View Model Delegate

extension MasterViewController: RedditPostsViewModelDelegate {
    
    func visiblePostsUpdated(posts: [RedditPost], newIndexes: [Int]) {
        if let refreshing = refreshControl?.isRefreshing, refreshing {
            tableView.reloadData()
            refreshControl?.endRefreshing()
        } else {
            insertNewRows(newIndexes: newIndexes)
        }
    }
    
    func receivedError(description: String) {
        // TODO
    }
    
}

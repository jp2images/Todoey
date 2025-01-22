//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Jeff Patterson on 1/21/25.
//  Copyright © 2025 App Brewery. All rights reserved.
//

import UIKit
import SwipeCellKit

/// Swipeable UITableViewCell/UICollectionViewCell based on the stock Mail.app, implemented in Swift.
/// https://swiftpackageindex.com/SwipeCellKit/SwipeCellKit
class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()


    }
    
    ///TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /// Create a reusable cell and adds it to the indexPath as a new category in the list
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",
                                                 for: indexPath) as! SwipeTableViewCell
        /// Set the delegate for all of the swipe functions to the cell
        cell.delegate = self
        return cell
    }
    
    /// Add swipe to delete functionality
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            print("Deleted Cell")
            self.updateModel(at: indexPath)
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "Delete-Icon")
        
        return [deleteAction]
    }
    
    /// Customize the behavior of the swipe
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        //options.transitionStyle = .border
        return options
    }

    /// Doesn't usually get called because it is overridden in the inherited classes. It can be called by
    /// calling it as a super.updateModel from the inherited class.
    func updateModel(at indexPath: IndexPath){
        // Update the data model
        
        print("Updating the data model from the Super Class method.")
    }
}

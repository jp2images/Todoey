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
    
    /// Add swipe to delete functionality
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            if let categoryToDelete = self.categories?[indexPath.row] {// as? Category {
                do {
                    try self.realm.write {
                        self.realm.delete(categoryToDelete) /// To remove the item at the selected row
                        print("delete row \(indexPath.row)")
                    }
                } catch {
                    print("Error saving done status, \(error)")
                }
                //tableView.reloadData()
            }
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

}

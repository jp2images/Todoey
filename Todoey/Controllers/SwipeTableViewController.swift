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
        tableView.rowHeight = 75.0
        //print("FROM super.viewDidLoad() No categories added yet")
    }
    
    ///TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /// Create a reusable cell and adds it to the indexPath as a new category in the list
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",
                                                 for: indexPath) as! SwipeTableViewCell
        /// Set the delegate for all of the swipe functions to the cell
        cell.delegate = self
        //print("super.tableView(cellForRowAt:) Add a cell?")
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

    /// Convert the rendomly generated color into a hex value to save the color in the database.
    func hexString(from color: UIColor) -> String {
        let components = color.cgColor.components ?? [0, 0, 0, 0]
        let red = Int(components[0] * 255)
        let green = Int(components[1] * 255)
        let blue = Int(components[2] * 255)
        let alpha = Int(components[3] * 255)
        return String(format: "#%02X%02X%02X%02X", red, green, blue, alpha)
    }
    
}


extension UIColor {
    var luminance: CGFloat {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        // Get the RGB components of the color
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        // Calculate the relative luminance
        return 0.2126 * red + 0.7152 * green + 0.0722 * blue
    }
    
    func contrastingForegroundColor() -> UIColor {
        return self.luminance > 0.5 ? .black : .white
    }
}

//// Example usage
//let backgroundColor = UIColor(red: 0.1, green: 0.6, blue: 0.3, alpha: 1.0)
//let foregroundColor = backgroundColor.contrastingForegroundColor()
//
//print("Background Color: \(backgroundColor)")
//print("Foreground Color: \(foregroundColor)")

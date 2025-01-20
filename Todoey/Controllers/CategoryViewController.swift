//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Jeff Patterson on 12/16/24.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class CategoryViewController: UITableViewController {

    let realm = try! Realm() /// Initialize a new Realm instance.

    var categories: Results<Category>? /// Change the type of Categories to a Realm style
                                       /// of container.
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories() /// Load all categories that are in the database on startup
    }
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1 /// If there are no categories then we will return (create)
                                      /// one cell to add some text for the user to see that
                                      /// there are no categories.
    }
    
    /// The example from the Packagmanager information
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SwipeTableViewCell
//        cell.delegate = self
//        return cell
//    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //print("cellAtRow: \(indexPath)")
        
        /// Create a reusable cell and adds it to the indexPath as a new category in the list
//        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! SwipeTableViewCell

        /// If the cell created is only one and ther is no name. We add text indicating that there are no
        /// categories created. (This is a nice notice to the user, instead of showing an empty screen.
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added yet"
        
        cell.delegate = self
         
        return cell
    }
    
    
    //MARK: - TableView Delegate Methods
    
    /// Notification when the user selects (taps) one of the CategoryViewController rows
    /// And send the user to the ToDoListViewController via the segue "GoToItems
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("You selected a Category in didSelectRowAt: \(categories[indexPath.row])")
        ///TODO create a constant for the "goToITems" Segue name
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        print("Going to View Controller: \(segue.destination)")
        
        /// Do a check for which seque was activated to navigate between more than one.
        /// In this applicaiton we only have one, but it will be good to have an example for how to do more.
        if segue.identifier == "goToItems" {
            let destinationVC = segue.destination as! TodoListViewController
            
            /// Make sure we have a valid category
            if let indexPath = tableView.indexPathForSelectedRow{
                destinationVC.selectedCategory = categories?[indexPath.row]
            }
        }
    }
    

    //MARK: - Data Manipulation Methods
    
    func save(category: Category) {
        do {
            try realm.write { /// Commit changes to the realm database
                realm.add(category)
            }
        } catch {
            print("Error saving categoryContext: \(error)")
        }
        tableView.reloadData()
    }
    
    /// Read the existing items into the application
    /// Use a default parameter for when we want to show all items
    /// Also have an external parameter name to improve readability.
    func loadCategories() {
        categories = realm.objects(Category.self)
        tableView.reloadData() /// Calls ALL the table datasouce methods
    }
    
    //MARK: - Add New Categories
    
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "",
                                      preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) {
            (action) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            self.save(category: newCategory)
        }
        
        alert.addAction(action)
        
        alert.addTextField { (alertTextField) in
            textField = alertTextField
            alertTextField.placeholder = "Add Category Name"
        }
        present(alert, animated: true, completion: nil)
    }
}

//MARK: - Swipe Cell Delegate Method
extension CategoryViewController: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            print("Item was pretend deleted")
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
}

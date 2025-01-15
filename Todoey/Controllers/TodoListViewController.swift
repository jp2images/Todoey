//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    var todoItems: Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /// Since we are filtering with categories we don't need this call any longer becasue as it is written
        /// it will load all items (Maybe not a bad feature in the future)
        //loadItems()
    }
    
    // MARK: - Tableview Datasource Methods
    
    /// Creates the 3 default cells created by the itemArray assignment.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1 /// Optional chaining
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //print("cellForRowAt: \(indexPath)")
        
        /// NOTE: There is a strange bug when using dequeueReusableCell that causes the cells to be
        /// reused when they leave the view via scrolling. The cell state (checked/uncheck) gets applies
        /// when the cell gets deallocated from the top and then reapplied at the bottom when cells not in
        /// the view are reused to show cells at the bottom.
        /// The fix is to associtate the cell state with the item in the cell and not with the cell by creating a
        /// a datamodel instead of simply using an array to fill the cells.
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        /// Optional binding check
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            /// Ternary operator ==> value == condition ? value if true : value if false
            cell.accessoryType = item.isComplete ? .checkmark : .none
        } else{
            cell.textLabel?.text = "No items added."
        }
        
        return cell
    }
    
    // MARK: - TableView Delegate Methods
    
    /// Triggers an event to toggle the item is completed. (Saving the data)
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("You selected \(itemArray[indexPath.row])")
        
        /// To Update existing items. We do something like:
        //itemArray[indexPath.row].setValue(value(forKey: StringValueToChange))

        /// To remove an item from the todo list. Order matters for this function. The item must remain at
        /// at the correct array index when updating the context otherwise the index will be out of sync
        /// with the item array that is displayed to the user.
        //context.delete(itemArray[indexPath.row])
        //itemArray.remove(at: indexPath.row)
        
        /// Toggle the isComplete property for each
        todoItems[indexPath.row].isComplete = !itemArray[indexPath.row].isComplete
        
       // saveItems()
        
        /// This creates an effect that when the user presses a cell, it gets highligted and then when
        /// released the cell is deselected. Showing an interestg effect.
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "",
                                      preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            //self.saveItems()
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        currentCategory.items.append(newItem)
                    }
                } catch {
                        print("Error saving new item.")
                    }
            }
        }
            
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Model Manipulation Methods
    
    func saveItems() {
//        do {
//            try itemsContext.save()
//        } catch {
//            print("Error saving context, \(error)")
//        }
//        /// Call the data source again
//        self.tableView.reloadData()
    }
    
    // Method commented out while implmenting Realm.
    /// Read the existing items into the application
    /// Use a default parameter for when we want to show all items
    /// Also have an external parameter name to improve readability.
    func loadItems() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        /// Call the data source
        tableView.reloadData()
    }

}

//MARK: - Search Bar Methods

//Commented out while implmenting Realm.
//extension TodoListViewController: UISearchBarDelegate {
//    
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        /// Read the text in the searchbar and search the database for that data
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
//
//        /// NSPredicate is a foundation object that is a query lanague
//        let predicate = NSPredicate(format: "title CONTAINS %@", searchBar.text!)
//        
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//        
//        loadItems(with: request, predicate: predicate)
//    }
//    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchBar.text?.count == 0 {
//            loadItems()
//            /// Dismiss this keyboard if it is showing and move the cursor from the searchBar
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
//        }
//    }
//}

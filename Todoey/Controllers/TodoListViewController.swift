//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    var itemArray = [Item]()
    //let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let context = (UIApplication.shared.delegate as!
                   AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Path to the simulator's data location
        print(FileManager.default.urls(for: .documentDirectory,
                                       in: .userDomainMask))
        loadItems()
    }
    
    // MARK: - Tableview Datasource Methods
    
    /// Creates the 3 default cells created by the itemArray assignment.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //print("cellForRowAt: \(indexPath)")
        
        /// NOTE: There is a strange bug when using dequeueReusableCell that causes the cells to be
        /// reused when they leave the view via scrolling. The cell state (checked/uncheck) gets applies
        /// when the cell gets deallocated fromt he top and then reapplied at the bottom when cells not in
        /// the view are reused to show cells at the bottom.
        /// The fix is to associtate the cell state with the item in the cell and not with the cell by creating a
        /// a datamodel instead of simply using an array to fill the cells.
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.isComplete ? .checkmark : .none
        
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
        itemArray[indexPath.row].isComplete = !itemArray[indexPath.row].isComplete
        
        
        saveItems()
        
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
            
            /// After changing the array contents from string to an object.
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.isComplete = false
            self.itemArray.append(newItem)
            
            self.saveItems()
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
        
        do {
            try context.save()
        } catch {
            print("Error saving context, \(error)")
        }
        /// Call the data source again
        self.tableView.reloadData()
    }
    
    /// Read the existing items into the application
    /// Use a default parameter for when we want to show all items
    /// Also have an external parameter name to improve readability.
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()) {
        
        /// One of the few areas in Swift that we must specify the data type for the entity.
        ///let request: NSFetchRequest<Item> = Item.fetchRequest<Item>()
        do {
            /// Pull everything in the data base into the context. Request is an array of Item(s)
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching items from context, \(error)")
        }
    }

}

//MARK: - Search Bar Methods
extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        /// Read the text in the searchbar and search the database for that data
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        print(searchBar.text!)
        
        /// NSPredicate is a foundation object that is a query lanague
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItems(with: request)
                
    }
}

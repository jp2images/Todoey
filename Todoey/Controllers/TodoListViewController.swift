//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    //["Find Mike", "Buy Eggos", "Destroy Demogorgon",
    //                 "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"
    //]
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem1 = Item()
        newItem1.title = "Find Mike"
        itemArray.append(newItem1)
        
        let newItem2 = Item()
        newItem2.title = "Buy Eggs"
        itemArray.append(newItem2)

        let newItem3 = Item()
        newItem3.title = "Destroy Demogorgon"
        itemArray.append(newItem3)
        
         let newItem4 = Item()
        newItem4.title = "New Item 4"
        itemArray.append(newItem4)
        
        let newItem5 = Item()
        newItem5.title = "New Item 5"
        itemArray.append(newItem5)
        
        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
            itemArray = items
        }
        
    }
    
    // MARK - Tableview Datasource Methods
    
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
    
    //MARK - TableView Delegate Methods
    
    /// Triggers an event to toggle the item is completed.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("You selected \(itemArray[indexPath.row])")
        
        /// Toggle the isComplete property for each
        itemArray[indexPath.row].isComplete = !itemArray[indexPath.row].isComplete
        
        /// Add a check mark to the selected cell.
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        /// Call the data source again
        tableView.reloadData()
        
        /// This creates an effect that when the user presses a cell, it gets highligted and then when
        /// released the cell is deselected. Showing an interestg effect.
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: nil, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            /// What happens when the user adds item.
            print("\(textField.text ?? "")")
            /// A text filed will NEVER == nil. So we can safely force unwrap it.
            /// can add validation code to make sure tha tit isn't empty. SHould alert the user and
            /// preven adding an empty item.
            //self.itemArray.append(textField.text!)
            
            /// After changing the array contents from string to an object.
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
            /// Never prints anything from the next statement because it happens too early and there
            /// is no value in the string variable.
            //print(alertTextField.text)
            //print("Now")
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}


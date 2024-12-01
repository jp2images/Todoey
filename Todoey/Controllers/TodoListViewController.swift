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

    var itemArray = [Item]()
    
    /// Create a path to a new plist we will call Items.plist
    let dataFilePath = FileManager.default
        .urls(for: .documentDirectory, in: .userDomainMask).first?
        .appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // let persinstentContainer = NSPersistentContainer(name: "DataModel")
        
        
        /// Path to the simulator's data location
        //////Users/jeff/Library/Developer/CoreSimulator/Devices/D2ED0674-9A67-489C-B12D-25F99310608C/data/Containers/Data/Application/32AE7D36-347C-4CF7-A8BE-C843CF238ADF/Documents/
        print("\(String(describing: dataFilePath))")
        
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
        
        /// Toggle the isComplete property for each
        itemArray[indexPath.row].isComplete = !itemArray[indexPath.row].isComplete
        
        /// Add a check mark to the selected cell.
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        saveItems()
        /// Call the data source again
        //tableView.reloadData()
        
        /// This creates an effect that when the user presses a cell, it gets highligted and then when
        /// released the cell is deselected. Showing an interestg effect.
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - Add New Items
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
            self.saveItems()

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
    
    //MARK: - Model Manipulation Methods
    func saveItems() {
        //self.defaults.set(self.itemArray, forKey: "TodoListArray")
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding item array, \(error)")
        }
        /// Call the data source again
        self.tableView.reloadData()
    }
    
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding item array, \(error)")
                
            }
        }
    }
    
    
}

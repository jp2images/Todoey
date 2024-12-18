//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Jeff Patterson on 12/16/24.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categories = [Category]()
    /// CRUD context for the data
    let categoryContext = (UIApplication.shared.delegate as!
                           AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("cellAtRow: \(indexPath)")
        
        /// Create a reusable cell and adds it to the indexPath as a new category in the list
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categories[indexPath.row].name
        
        //let category = categories[indexPath.row]
        //cell.textLabel?.text = category.name
        
        return cell
    }
    
    
    //MARK: - TableView Delegate Methods
    /// Notification when the user selects one of the CategoryViewController rows
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected didSelectRowAt: \(categories[indexPath.row])")
        
        saveCategories()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //MARK: - Add New Categories
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "",
                                      preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newCategory = Category(context: self.categoryContext)
            newCategory.name = textField.text!
            self.categories.append(newCategory)
            self.saveCategories()
        }
        alert.addAction(action)
        
        alert.addTextField { (alertTextField) in
            textField = alertTextField
            alertTextField.placeholder = "Add Category Name"
        }
        present(alert, animated: true, completion: nil)
    }

    //MARK: - Data Manipulation Methods
    func saveCategories() {
        do {
            try categoryContext.save()
        } catch {
            print("Error saving categoryContext: \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    /// Read the existing items into the application
    /// Use a default parameter for when we want to show all items
    /// Also have an external parameter name to improve readability.
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        
        do {
            /// Pull all of the category types from the database to list to the user.
            categories = try categoryContext.fetch(request)
            // print("categoryArray count: \(categories.count)")
        } catch {
            print("Error loading categories: \(error)")
        }
        tableView.reloadData()
    }
    
}

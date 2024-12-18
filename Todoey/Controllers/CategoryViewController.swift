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

    var categoryArray = [Category]()
    let categoryContext = (UIApplication.shared.delegate as!
                           AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("cellAtRow: \(indexPath)")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category = categoryArray[indexPath.row]
        cell.textLabel?.text = category.name
        
        return cell
    }
    
    
    //MARK: - TableView Delegate Methods
    /// Notification when the user selects one of the CategoryViewController rows
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected didSelectRowAt: \(categoryArray[indexPath.row])")
        
        saveCategories()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //MARK: - Add New Categories
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "",
                                      preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            let newCategory = Category(context: self.categoryContext)
            newCategory.name = textField.text!
            self.categoryArray.append(newCategory)
            self.saveCategories()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter Category Name"
            textField = alertTextField
        }
        alert.addAction(action)
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
            categoryArray = try categoryContext.fetch(request)
            print("categoryArray count: \(categoryArray.count)")
        } catch {
            print("Error loading categories: \(error)")
        }
        tableView.reloadData()
    }
    
}

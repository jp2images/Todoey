//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Jeff Patterson on 12/16/24.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {

    let realm = try! Realm()
    var categories: Results<Category>? /// Change the type of Categories to a Realm style
                                       /// of container.
    override func viewDidLoad() {
        super.viewDidLoad()
        //loadCategories()
    }
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("cellAtRow: \(indexPath)")
        
        /// Create a reusable cell and adds it to the indexPath as a new category in the list
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added yet"
        
        return cell
    }
    
    
    //MARK: - TableView Delegate Methods
    /// Notification when the user selects one of the CategoryViewController rows
    /// And send the user to the ToDoListViewController via the segue "GoToItems
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("You selected a Category in didSelectRowAt: \(categories[indexPath.row])")
        ///TODO create a constant for the "goToITems" Segue name
        performSegue(withIdentifier: "goToItems", sender: categories?[indexPath.row])
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
    func save(category: Category) { /// Saving with Realm.
    //func saveCategories() { /// Saving with CoreData
        do {
            //try categoryContext.save() /// This saves the context which is used in CoreData
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving categoryContext: \(error)")
        }
        self.tableView.reloadData()
    }
    
    /// Read the existing items into the application
    /// Use a default parameter for when we want to show all items
    /// Also have an external parameter name to improve readability.
    func loadCategories() { ///Using Realm we don'tt need to make this method
        /// work with outside arguments.
        /// WIth Real we read all of the categories in one line
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    //MARK: - Add New Categories
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "",
                                      preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
        }
        alert.addAction(action)
        
        alert.addTextField { (alertTextField) in
            textField = alertTextField
            alertTextField.placeholder = "Add Category Name"
        }
        present(alert, animated: true, completion: nil)
    }
}

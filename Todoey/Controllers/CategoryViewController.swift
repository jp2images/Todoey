//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Jeff Patterson on 12/16/24.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import UIKit
import CoreData
//import RealmSwift

class CategoryViewController: UITableViewController {

    let realm = try! Realm()
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
        
        return cell
    }
    
    
    //MARK: - TableView Delegate Methods
    /// Notification when the user selects one of the CategoryViewController rows
    /// And send the user to the ToDoListViewController via the segue "GoToItems
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected a Category in didSelectRowAt: \(categories[indexPath.row])")
        ///TODO create a constant for the "goToITems" Segue name
        performSegue(withIdentifier: "goToItems", sender: categories[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        print("Going to View Controller: \(segue.destination)")
        /// Do a check for which seque was activated to navigate between more than one.
        /// In this applicaiton we only have one, but it will be good to have an example for how to do more.
        if segue.identifier == "goToItems" {
            let destinationVC = segue.destination as! TodoListViewController
            
            /// Make sure we have a valid category
            if let indexPath = tableView.indexPathForSelectedRow{
                destinationVC.selectedCategory = categories[indexPath.row] 
                
            }
        }
    }
    

    //MARK: - Data Manipulation Methods
    func save(category: Category) { /// Saving with Realm.
    //func saveCategories() { /// Saving with CoreData
        do {
            //try categoryContext.save() /// This saves the context which is used in CareData
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
    func loadCategories() {
    //func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {

        ///let request : NSFetchRequest<Category> = Categoty.fetchRequest() /// This was changed to make it a parameter that we pass into the method.
        /// At some point the video had it back when trying to add Realm and then the entire content of the
        /// method was commented out. ????
        
// Removed during Realm implementation
//        do {
//            /// Pull all of the category types from the database to list to the user.
//            categories = try categoryContext.fetch(request)
//            // print("categoryArray count: \(categories.count)")
//        } catch {
//            print("Error loading categories: \(error)")
//        }
//        tableView.reloadData()
    }
    
    //MARK: - Add New Categories
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "",
                                      preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newCategory = Category /// When using Realm and the Calss Category
                                       //let newCategory = Category(context: self.categoryContext) /// For use with the SQLite DB and CoreData
            newCategory.name = textField.text!
            self.categories.append(newCategory)
            //self.saveCategories() /// Call CoreData save thehod
            self.save(category: newCategory) /// Call Real save method
        }
        alert.addAction(action)
        
        alert.addTextField { (alertTextField) in
            textField = alertTextField
            alertTextField.placeholder = "Add Category Name"
        }
        present(alert, animated: true, completion: nil)
    }
}

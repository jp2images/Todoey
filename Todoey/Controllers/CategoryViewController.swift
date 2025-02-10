//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Jeff Patterson on 12/16/24.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import CyaneaOctopus

class CategoryViewController: SwipeTableViewController {
    let realm = try! Realm() /// Initialize a new Realm instance.
    var categories: Results<Category>? /// Change the type of Categories to a Realm style
                                       /// of container.
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories() /// Load all categories that are in the database on startup
        tableView.separatorStyle = .none /// This doesn't seem to be necessary in Swift6?
    }
    
    //MARK: - TableView Datasource Methods
    
    // This is running twice on startup? Need to learn why
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = categories?.count ?? 1
        print("Category count: \(count)")
        return count /// If there are no categories then we will return (create)
                     /// one cell to add some text for the user to see that
                     /// there are no categories.
    }
    
    // This isn't getting called on startup when there is no content. :|
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /// Call the base class method that will get the cell and return it so other things can be done to it here.
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        /// If the cell created is only one and there is no name. We add text indicating that there are no
        /// categories created. (This is a nice notice to the user, instead of showing an empty screen.
  
        if (categories?[indexPath.row]) != nil {
            cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added yet"
            //        var content = cell.defaultContentConfiguration()
            //        content.text = categories?[indexPath.row].name ?? "No categories added yet"
            //        cell.contentConfiguration = content
            
            if let colorString: String? = categories?[indexPath.row].color {
                cell.backgroundColor = UIColor(hexString: (colorString ?? UIColor.lightGray.toHexString(includeAlpha: false)) ?? "#1D9BF6")
                cell.textLabel?.textColor = cell.backgroundColor!.contrastingForegroundColor()
            }
            //print("Color string: \(String(describing: colorString))")
        }
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
        print("loadCategories running...")
        categories = realm.objects(Category.self)
        tableView.reloadData() /// Calls ALL the table datasouce methods
    }
    
    //MARK: - Delete Data from Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        super.updateModel(at: indexPath)
        
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error deleting category: \(error)")
            }
        }
        
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
            let categoryColor: UIColor = .randomFlatColor() ?? .gray
            newCategory.color = self.hexString(from: categoryColor)
            print("New Color: \(categoryColor)")
            self.save(category: newCategory)
        }
        
        alert.addAction(action)
        
        alert.addTextField { (alertTextField) in
            textField = alertTextField
            alertTextField.placeholder = "Add Category Name"
        }
        present(alert, animated: true, completion: nil)
    }
        
        
//        /// Convert the rendomly generated color into a hex value to save the color in the database.
//        func hexString(from color: UIColor) -> String {
//            let components = color.cgColor.components ?? [0, 0, 0, 0]
//            let red = Int(components[0] * 255)
//            let green = Int(components[1] * 255)
//            let blue = Int(components[2] * 255)
//            let alpha = Int(components[3] * 255)
//            return String(format: "#%02X%02X%02X%02X", red, green, blue, alpha)
//        }
        
}

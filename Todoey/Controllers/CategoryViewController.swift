//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Testing on 9/30/18.
//  Copyright © 2018 Yero. All rights reserved.
//

import UIKit
// import CoreData
import RealmSwift

class CategoryViewController: UITableViewController {
    
    // Initialize Realm
    let realm = try! Realm()
    
    // Collection of result categories objects
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }
    
    
    // MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // if categories is nill then return 1
        return categories?.count ?? 1
    }
    
    // Build the Cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Identifier is the TableView name or identify
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCategoryCell", for: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added yet."
        
        return cell
    }
    
    
    // MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    // Setting the selectedCategory variable on 'TodoListViewController' before perform the segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! TodoListViewController
        
        // current selected row is passed to TodoListVC
        if let indexPatch = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPatch.row]
        }
    }
    
    
    // MARK: - Add new Categories
    @IBAction func buttonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (alertAction) in
            
            // What will happend once the user clicks the 'Add' action button on the UIAlert
            if textField.text != "" {
                
                let newCategory = Category()
                newCategory.name = textField.text!
                
                self.save(category: newCategory) // save the title (saving the array)
            }
            
            self.tableView.reloadData()
        }
        
        // adding a text field input to the alert
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Enter new category"
            
            // A reference to the textField variable created previouuly
            textField = alertTextField
        }
        
        // Adding the action to the alert
        alert.addAction(action)
        
        // show the alert
        present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - Data Manipulation Methods
    func save(category: Category) {
        
        do {
            // Realm Database
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving context, \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategories() {
        
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
}

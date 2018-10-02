//
//  ViewController.swift
//  Todoey
//
//  Created by Yero on 9/24/18.
//  Copyright © 2018 Yero. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    var selectedCategory : Category? {
        // using didSet to load items when selectedCategory variable has a value
        didSet {
            loadItems()
        }
    }
    
    // getting the context object from the delegate (CoreData DB)
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
    }
    
    // MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Identifier is the TableView name or identify
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        // allowing accesories (checkmark) on the cell
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    
    // MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Deleteing Items from context first and then form the array
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        // Save the changes
        saveItems()
        
//        tableView.reloadData()
        
        // Deselect row inmediatelly
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    
    // MARK: - Add New Item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (alertAction) in
            
            // What will happend once the user clicks the 'Add' action button on the UIAlert
            if textField.text != "" {
                
                let newItem = Item(context: self.context)
                newItem.title = textField.text!
                newItem.done = false
                // Asing the Category
                newItem.parentCategory = self.selectedCategory
                
                self.itemArray.append(newItem)
                
            }
            
            self.saveItems() // save the title (saving the array)
          
            self.tableView.reloadData()
        }
        
        // adding a text field input to the alert
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Enter new item"
            textField = alertTextField

        }
        
        // Adding the action to the alert
        alert.addAction(action)
        
        // show the alert
        present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - Model Manipulation Methods
    func saveItems() {
        
        do {
            
            // CoreData Database
            try context.save()
        } catch {
            print("Error saving context, \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
        // load only the items that belongs to the selectedCategory
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        // Creating a Coumpound Predicate to integrate more than one Predicate
        // Using Optional Binding because of the Optional Predicate Argument
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
    }
}

//MARK: - Search Bar Methods
extension TodoListViewController: UISearchBarDelegate {
    
    // MARK: - SearchBar Delegate Methods
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let searchRequest : NSFetchRequest<Item> = Item.fetchRequest()
        
        // To query data [cd] stand for dicritive and case INSENSITIVE
        let searchPredicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        // Sort the data (predicators is an array)
        searchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: searchRequest, predicate: searchPredicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {
            loadItems()
            
            // hide the keyboardr
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
}

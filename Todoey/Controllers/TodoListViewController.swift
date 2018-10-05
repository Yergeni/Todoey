//
//  ViewController.swift
//  Todoey
//
//  Created by Yero on 9/24/18.
//  Copyright © 2018 Yero. All rights reserved.
//

import UIKit
//import CoreData
import RealmSwift

class TodoListViewController: UITableViewController {

    var todoItem: Results<Item>?
    let realm = try! Realm()

    var selectedCategory : Category? {
        // using didSet to load items when selectedCategory variable has a value
        didSet {
            loadItems()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItem?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // Identifier is the TableView name or identify
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)

        if let item = todoItem?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
            // allowing accesories (checkmark) on the cell
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items added yet."
        }
        
        return cell
    }


    // MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let item = todoItem?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                    print("Error trying to update the item \(error)")
                }
            }
        
        tableView.reloadData()
        
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
                if let currentCategory = self.selectedCategory {
                    do {
                        // Realm Database
                        try self.realm.write {
                            let newItem = Item()
                            newItem.title = textField.text!
                            newItem.dateCreated = Date()
                            
                            // Add the item to current category
                            currentCategory.items.append(newItem)
                            self.realm.add(newItem)
                        }
                    } catch {
                        print("Error saving context, \(error)")
                    }
                }
           }
            
            self.tableView.reloadData()
        }
        
        // ALERT ATTRIBUTES
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
    func loadItems() {
        
        todoItem = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
}

//MARK: - Search Bar Methods
extension TodoListViewController: UISearchBarDelegate {

    // MARK: - SearchBar Delegate Methods
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        todoItem = todoItem?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchBar.text?.count == 0 {
            loadItems()

            // hide the keyboard
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }

}

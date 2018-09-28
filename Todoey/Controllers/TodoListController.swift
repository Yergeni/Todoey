//
//  ViewController.swift
//  Todoey
//
//  Created by Testing on 9/24/18.
//  Copyright © 2018 Yero. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    // local storage
    let defaults =  UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem = Item(aTitle: "Find Mike")
        newItem.done = true
        itemArray.append(newItem)
        
        let newItem1 = Item(aTitle: "Watch Movie")
        itemArray.append(newItem1)
        
        // Add the local storage saved array to the itemArray array to populate what was saved before app gets terminated
        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
            itemArray = items
        }
        
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
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        tableView.reloadData()
        
        // Deselect row inmediatelly
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    
    // MARK: - Add New Item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (alertAction) in
            
            // What will happend once the user clicks the action button on the UIAlert
            if textField.text != "" { self.itemArray.append(Item(aTitle: textField.text!)) }
            
            // Add the array to the local storage
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            self.tableView.reloadData()
            
        }
        
        // adding a text field to the alert
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Enter new item"
            textField = alertTextField

        }
        
        // Adding the action to the alert
        alert.addAction(action)
        
        // show the alert
        present(alert, animated: true, completion: nil)
    }
    

}


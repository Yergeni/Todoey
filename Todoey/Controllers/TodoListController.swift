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
    
    // get the local directory on the device
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem = Item(aTitle: "Find Mike")
        newItem.done = true
        itemArray.append(newItem)
        
        let newItem1 = Item(aTitle: "Watch Movie")
        itemArray.append(newItem1)
        
        loadItems()
        
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
        
        saveItems() // to safe the done property (saving the array)
        
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
            
            self.saveItems() // save the title (saving the array)
          
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
    
    
    // MARK: - Model Manipulation Methods
    func saveItems() {
        
        // create an encoder to convert datatypes instances to encoder lists
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding item arra, \(error)")
        }
    }
    
    func loadItems() {
        
        if let data = try? Data(contentsOf: dataFilePath!) {
            
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding item array \(error)")
            }
        }
        
    }
    

}


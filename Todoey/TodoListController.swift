//
//  ViewController.swift
//  Todoey
//
//  Created by Testing on 9/24/18.
//  Copyright © 2018 Yero. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    let itemArray = ["Find Mike", "Buy Eggos", "Destroy Demogorgon"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Identifier is the TableView name or identify
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    
    // MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // get the cell index
//        let indexCell = tableView.indexPathForSelectedRow
        
        // get the cell object
        let selectedCell = tableView.cellForRow(at: indexPath) as! UITableViewCell
        
        // to deselect the current row with animation
        tableView.deselectRow(at: indexPath, animated: true)
        
        let accesoryType = selectedCell.accessoryType.rawValue
        
        // allowing accesories (checkmark) on the cell
        if accesoryType == 0 {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        } else if accesoryType == 3 {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        
        
        
        
        print(accesoryType)
        print(indexPath.row)
        print(itemArray[indexPath.row])
    }
    


}


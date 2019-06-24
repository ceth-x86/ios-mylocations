//
//  CategoryPickerViewController.swift
//  My Locations
//
//  Created by demas on 24/06/2019.
//  Copyright © 2019 demas. All rights reserved.
//

import UIKit

class CategoryPickerViewController: UITableViewController {
    
    var selectCategoryName = ""
    let categories = [
        "No Category",
        "Apple Store",
        "Bar",
        "Bookstore",
        "Club",
        "GroceryStore",
        "Historic Building",
        "House",
        "Icecream Vendor",
        "Landmark",
        "Park"
    ]
    
    var selectedIndexPath = NSIndexPath()
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! UITableViewCell
        let categoryName = categories[indexPath.row]
        cell.textLabel?.text = categoryName
        
        if categoryName == selectCategoryName {
            cell.accessoryType = .checkmark
            selectedIndexPath = indexPath as NSIndexPath
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row != selectedIndexPath.row {
            if let newCell = tableView.cellForRow(at: indexPath) {
                newCell.accessoryType = .checkmark
            }
        }
        
        if let oldCell = tableView.cellForRow(at: selectedIndexPath as IndexPath) {
            
            oldCell.accessoryType = .none
        }
        
        selectedIndexPath = indexPath as NSIndexPath
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "PickedCategory" {
            let cell = sender as! UITableViewCell
            if let indexPath = tableView.indexPath(for: cell) {
                selectCategoryName = categories[indexPath.row]
            }
        }
    }
}

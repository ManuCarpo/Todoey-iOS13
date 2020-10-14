//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    
    var itemArray = [Item]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print(dataFilePath)
        
        func addElement(item: Item, _ title: String) {
            item.title = title
            itemArray.append(item)
        }
        
        let newItem = Item()
        addElement(item: newItem, "Pippo")
        
        let newItem2 = Item()
        addElement(item: newItem2, "Pluto")
        
        let newItem3 = Item()
        addElement(item: newItem3, "Flauro")
        
        //        // Permetto all'utente di visualizzare i cambiamenti che ha fatto negli utilizzi precedenti, l'array salvato nel defaults viene aggiornato nella parte "addButton: New Items"
        //        if let items = defaults.array(forKey: "ToDoListArray") as? [Item] {
        //            itemArray = items
        //        }
        
    }
    //MARK: -  TableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        // Qui sotto uso il Ternary Operator, identico ad un if statment o uno switch
        // value = condition ? valueIfTrue : valueIfFalse
        cell.accessoryType = itemArray[indexPath.row].done == true ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Cliccando nella cella, rendo il checkmark visibile o non visibile, all'opposto di ciò che visualizzo nella cella prima di cliccare
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: -  addButton: New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        //Creato un allert con titolo, messaggio e stile
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        // Creata un' azione che triggera quando l'user clicca il pulsante "Add Item"
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let newItem = Item()
            newItem.title = textField.text!
            
            // Viene aggiunto ciò che scrive l'utente all'array iniziale
            self.itemArray.append(newItem)
            
            self.saveItems()
            
        }
        
        // Ho dato all'allert un text field che per permettere all'utente di scriverci
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        
        // Trigger dell'azione
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: -  Save Items
    
    func saveItems() {
        // Create an object that encodes instances of data types to a property list.
        let encoder = PropertyListEncoder()
        
        //Blocco do-catch per controllare eventuali errori quando aggiungo alla property list nuovi elementi
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch  {
            print("Error encoding item array, \(error)")
        }
        
        // Viene aggiornato il Database per permettere alla view di far vedere i nuovi elementi aggiunti nell'array
        self.tableView.reloadData()
        
    }
}


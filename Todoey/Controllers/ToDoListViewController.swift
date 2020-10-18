//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    //Creo un oggetto (copia del BluePrint della classe AppDelegate).proprietà
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Permetto all'utente di visualizzare i cambiamenti che ha fatto negli utilizzi precedenti, l'array salvato nel defaults viene aggiornato nella parte "addButton: New Items"
            loadItems()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
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
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
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
    
    //MARK: -  Save Items and Load Items
    //Queste due funzioni servono per salvare gli elementi nell' NSDecoder e per caricare nelle view dell'app gli stessi elementi salvati. Nella prima la funzione salva gli elmenti sottoforma di elementi diversi appunto grazie alla PropertyListEncoder(). Nella seconda facciamo il processo inverso: attraverso la PropertyListDecoder() facciamo conoscere all'app gli elementi salvati.
    
    //Creata funzione che salva nella P.List gli elementi creati dall'utente
    func saveItems() {
        
        
        //Blocco do-catch per controllare eventuali errori quando aggiungo alla property list nuovi elementi
        do {
            try context.save()
        } catch  {
            print("Errorsaving context \(error)")
        }
        
        // Viene aggiornato il Database per permettere alla view di far vedere i nuovi elementi aggiunti nell'array
        self.tableView.reloadData()
        
    }
    
    //    Creata funzione che aggiunge alla view l'itemArray: i nuovi elementi creati dall'utente, cioè gli elementi salvati nel Core Data
    func loadItems() {
        //Creo una costante che recupera dati attraverso il criterio "NSFetchRequest<Item>" (usato per recuperare data dal persistent store)
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        do {
            // Return an array of objects that meet the criteria specified by a given fetch request. The given fetch request is "request". Salvo i dati uguagliando la funzione all'itemArray.
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context\(error)")
        }
        
    }
}

//  Qui sotto il metodo per eliminare dati dal Core Data
//  context.delete(itemArray[indexPath.row])
//  itemArray.remove(at: indexPath.row)
//  saveItems()


//MARK: -  Search Bar

//Nella SearchBar posso cercare lettere/parole che sono contenute nell'array. Visualizzo nell'app solo le celle che contengono quelle lettere/parole
extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context\(error)")
        }
        
        tableView.reloadData()
        
    }
    
    
    //Una volta cliccata la x nella searchBar, vengono dinuovo visualizzate tutte le celle. Inoltre cessa di essere vista la linea nella searchBar e scompare la keyboard
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            let request: NSFetchRequest<Item> = Item.fetchRequest()
            do {
                itemArray = try context.fetch(request)
            } catch {
                print("Error fetching data from context\(error)")
            }
            tableView.reloadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
        
        
    }
}

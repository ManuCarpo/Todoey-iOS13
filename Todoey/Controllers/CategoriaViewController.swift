//
//  CategoriaViewController.swift
//  Todoey
//
//  Created by Emanuele Carpigna on 19/10/2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class CategoriaViewController: UITableViewController {
    
    var categoriaArray = [Categoria]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategoria()

    }

    // MARK: - TableView

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriaArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCategoriaCell", for: indexPath)
        
        cell.textLabel?.text = categoriaArray[indexPath.row].name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     // creare un passaggio all'altra view (possibilmente con il "Disclosure Indicator" alla destra)
    }
    
    //MARK: -  addButton: New Categoria

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        //Creato un allert con titolo, messaggio e stile
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        // Creata un' azione che triggera quando l'user clicca il pulsante "Add Category"
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newCategoria = Categoria(context: self.context)
            newCategoria.name = textField.text!
            // Viene aggiunto ciò che scrive l'utente all'array iniziale
            self.categoriaArray.append(newCategoria)
            
            self.saveCategoria()
        }
        
        // Ho dato all'allert un text field che per permettere all'utente di scriverci
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Category"
            textField = alertTextField
        }
        
        // Trigger dell'azione
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    //MARK: -  Save Items and Load Items
    
    func saveCategoria() {
        
        
        //Blocco do-catch per controllare eventuali errori quando aggiungo alla property list nuovi elementi
        do {
            try context.save()
        } catch  {
            print("Error saving category \(error)")
        }
        
        // Viene aggiornato il Database per permettere alla view di far vedere i nuovi elementi aggiunti nell'array
        self.tableView.reloadData()
        
    }
    
    func loadCategoria() {
        //Creo una costante che recupera dati attraverso il criterio "NSFetchRequest<Item>" (usato per recuperare data dal persistent store)
        let request: NSFetchRequest<Categoria> = Categoria.fetchRequest()
        do {
            // Return an array of objects that meet the criteria specified by a given fetch request. The given fetch request is "request". Salvo i dati uguagliando la funzione all'itemArray.
            categoriaArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context\(error)")
        }
        
        tableView.reloadData()
    }
}

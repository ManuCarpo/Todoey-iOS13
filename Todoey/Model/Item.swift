//
//  ModelItemArray.swift
//  Todoey
//
//  Created by Emanuele Carpigna on 13/10/2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation


// Creata la classe con protocollo Encodable per essere utilizzata nella plist (al fine di salvare i dati inseriti dall'utente)
class Item: Codable {
    var done: Bool = false
    var title: String = ""
}

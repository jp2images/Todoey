//
//  Category.swift
//  Todoey
//
//  Created by Jeff Patterson on 1/2/25.
//  Copyright © 2025 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name: String = ""
    
    /// Forward relationship with the table Items.
    let items = List<Item>()
}

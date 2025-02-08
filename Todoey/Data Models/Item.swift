//
//  Item.swift
//  Todoey
//
//  Created by Jeff Patterson on 1/2/25.
//  Copyright © 2025 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object { // Create a class based on the RealmObject
    @objc dynamic var title: String = ""
    @objc dynamic var isComplete: Bool = false
    @objc dynamic var dateAdded: Date? = Date()
    
    /// Reverse relationship with Category table
    /// Linking objects are auto updating containers that represent zero or more objects that are linked to
    /// its owning object (the inverse relationship)
    /// "items" is the property name in the Item class
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}

//
//  Data.swift
//  Todoey
//
//  Created by Jeff Patterson on 1/8/25.
//  Copyright © 2025 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Data: Object { // Create a class based on the RealmObject
    @objc dynamic var name: String = ""
    @objc dynamic var age: Int = 0
    
    /// Reverse relationship with Category table
    //var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}

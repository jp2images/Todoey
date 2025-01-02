//
//  Category.swift
//  Todoey
//
//  Created by Jeff Patterson on 1/2/25.
//  Copyright © 2025 App Brewery. All rights reserved.
//

import Foundation
//import RealmSwift
import MongoSwift

class Categoty: Object {
//    @Persisted var id: Int
//    @Persisted var name: String = ""
//    @Persisted var color: String
    
//    override class func primaryKey() -> String {
//        return "id"
//    }
    
    @objc dynamic var name: String = ""
    
    let items = List<Item>()
    
    
}

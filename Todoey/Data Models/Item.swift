//
//  Item.swift
//  Todoey
//
//  Created by Jeff Patterson on 1/2/25.
//  Copyright © 2025 App Brewery. All rights reserved.
//

import Foundation
import MongoSwift
//import RealmSwift

class Item: Object { // Create a class based on the RealmObject
    @objc dynamic var title: String = ""
    @objc dynamic var isComplete: Bool = false
}

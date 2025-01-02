//
//  Data.swift
//  Todoey
//
//  Created by Jeff Patterson on 12/27/24.
//  Copyright © 2024 App Brewery. All rights reserved.
//


//Not using this file as we are creating some new files for the data context.

import Foundation
//import RealmSwift

/// Using the "Code-along" code witht eh Udemy course. Actually need to change this to Atlas Compass? or
/// some other DB type TBD. Currently trying Atals but need to make sure the functionality in the class is
/// identifired to use in the new DB. (Real has been deprecated by MongoDB)
class Data: Object {
    // Create Realm Properties
    /// Using the the dynamic keyword enables dynmic dispatch which is an Objective-C construct. Realm
    /// will use it to update changes. Also since it is Obj-C we need to tag it as such with @objc.
    /// Short answer, Realm uses "@objc dynamic" to monitor for changes and update the DB accordingly.
    @objc dynamic var name: String = ""
    @objc dynamic var age: Int = 0
    
}

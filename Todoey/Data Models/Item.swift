//
//  Item.swift
//  Todoey
//
//  Created by Jeff Patterson on 11/25/24.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation

class Item: Encodable {
    //class Item: Codable {
    //let id: UUID
    var title: String = ""
    var isComplete: Bool = false
}
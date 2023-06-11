//
//  Model.swift
//  SneakerStore
//
//  Created by A M on 03.06.2023.
//

import Foundation
import SwiftUI

struct User {
    var username: String
    var password: String
}

struct Product: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let description: String
    let price: Int
    let image: Image
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
        
    static func ==(lhs: Product, rhs: Product) -> Bool {
        return lhs.id == rhs.id
    }
}

struct Order: Hashable {
    let name: String
    let date: Date
    let numberOfItems: Int
    let price: Int
}

let productsData = [
    Product(name: "Dolce & Gabanna", description: "Кеды с принтом граффити", price: 1251, image: Image("dg")),
    Product(name: "Off-White", description: "Кроссовки Off-Court 3.0", price: 1251, image: Image("offwhite")),
    Product(name: "Jordan", description: "Кеды с принтом граффити", price: 1251, image: Image("jordan")),
    Product(name: "Jordan", description: "Кеды с принтом граффити", price: 1251, image: Image("jordan1"))
]

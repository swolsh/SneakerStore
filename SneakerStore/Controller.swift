//
//  Controller.swift
//  SneakerStore
//
//  Created by A M on 03.06.2023.
//

import Foundation
import WebKit
import SwiftUI

class UserManager: ObservableObject {
    static var shared = UserManager()
    
    private var users: [User] = []
    
    func registerUser(username: String, password: String) {
        let user = User(username: username, password: password)
        users.append(user)
        storeUserData()
    }
    
    func authorizeUser(username: String, password: String) -> Bool {
        let matchingUser = users.first { $0.username == username && $0.password == password }
        return matchingUser != nil
    }
    
    func storeUserData() {
        let userData = users.map { ["username": $0.username, "password": $0.password] }
        UserDefaults.standard.set(userData, forKey: "UserArray")
    }
    
    func retrieveUserData() -> [User]? {
        guard let userData = UserDefaults.standard.array(forKey: "UserArray") as? [[String: String]] else {
            return nil
        }

        var users = userData.compactMap { dict -> User? in
            guard let username = dict["username"], let password = dict["password"] else {
                return nil
            }
            return User(username: username, password: password)
        }
        return users
    }
    
//    func updateUserData(newUsername: String, newPassword: String) {
//        guard let index = users.firstIndex(where: { $0.username == newUsername }) else {
//            return
//        }
//
//        users[index].username = newUsername
//        users[index].password = newPassword
//
//        storeUserData()
//    }
    
    func updateUserData(oldUsername: String, newUsername: String, newPassword: String) {
        guard let index = users.firstIndex(where: { $0.username == oldUsername }) else {
            return
        }
        
        users[index].username = newUsername
        users[index].password = newPassword
        
        storeUserData()
    }
    
//    func printRegisteredUsers() {
//        let registeredUsers = UserManager.shared.retrieveUserData()
//        for user in registeredUsers! {
//            print("Username: \(user.username), Password: \(user.password)")
//        }
//    }
}


class Cart: ObservableObject {
    @Published var products: [Product: Int] = [:]
//    @Published var singleOrder: [Product: Int] = [:]

    var totalPrice: Int {
        products.reduce(0) { $0 + ($1.key.price * Int($1.value)) }
    }
    
    var totalQuantity: Int {
        products.values.reduce(0, +)
    }
    
    func addToCart(_ product: Product) {
        if let count = products[product] {
            products[product] = count + 1
        } else {
            products[product] = 1
        }
    }
    
    func removeFromCart(_ product: Product) {
        if let count = products[product], count > 1 {
            products[product] = count - 1
        } else {
            products.removeValue(forKey: product)
        }
    }
    
    func removeAllFromCart(_ product: Product) {
        products[product] = nil
    }
    
    
//    func addToSingleOrder(_ product: Product) {
//        if let count = singleOrder[product] {
//            singleOrder[product] = count + 1
//        } else {
//            singleOrder[product] = 1
//        }
//    }
    
//    func addToSingleOrderAll() {
////        singleOrder.removeAll()
//
//        for (product, count) in products {
//            singleOrder[product] = count
//        }
//    }

    
}

class SingleOrder: ObservableObject {
    @Published var singleOrder: [Product: Int] = [:]
    
    let orderHistory: OrderHistory
        
    init(orderHistory: OrderHistory) {
        self.orderHistory = orderHistory
    }
    
    func addToSingleOrderAll(from cart: Cart) {
        for (product, count) in cart.products {
            singleOrder[product] = count
            
//            let order = Order(name: product.name, date: Date(), numberOfItems: totalQuantity, price: totalPrice)
//            orderHistory.addToOrderHistory(order)
        }
    }
    
    var totalPrice: Int {
        singleOrder.reduce(0) { $0 + ($1.key.price * Int($1.value)) }
    }
    
    var totalQuantity: Int {
        singleOrder.values.reduce(0, +)
    }

}


class OrderHistory: ObservableObject {
    @Published var orders: [Order: Int] = [:]
    
    func addToOrderHistory(_ order: Order) {
        if let count = orders[order] {
            orders[order] = count + 1
        } else {
            orders[order] = 1
        }
    }
}



//struct WebView: UIViewRepresentable {
//    // 1
//    let url: URL
//
//    
//    // 2
//    func makeUIView(context: Context) -> WKWebView {
//
//        return WKWebView()
//    }
//    
//    // 3
//    func updateUIView(_ webView: WKWebView, context: Context) {
//
//        let request = URLRequest(url: url)
//        webView.load(request)
//    }
//}

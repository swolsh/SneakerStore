//
//  Controller.swift
//  SneakerStore
//
//  Created by A M on 03.06.2023.
//

import Foundation
import WebKit

class UserManager {
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
        
        let users = userData.compactMap { dict -> User? in
            guard let username = dict["username"], let password = dict["password"] else {
                return nil
            }
            return User(username: username, password: password)
        }
        return users
    }
    
    func printRegisteredUsers() {
        let registeredUsers = UserManager.shared.retrieveUserData()
        for user in registeredUsers! {
            print("Username: \(user.username), Password: \(user.password)")
        }
    }
}

//class SessionManager: ObservableObject {
//    @Published var isLoggedOut = true
//
//    func logout() {
//        isLoggedOut = true
//    }
//}


class Cart: ObservableObject {
    @Published var products: [Product: Int] = [:]

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

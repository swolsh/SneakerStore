//
//  SneakerStoreApp.swift
//  SneakerStore
//
//  Created by A M on 03.06.2023.
//

import SwiftUI

@main
struct SneakerStoreApp: App {
    @State private var isLoggedOut = false
    
    var body: some Scene {
        WindowGroup {
            ContentView(isLoggedOut: $isLoggedOut)
        }
    }
}

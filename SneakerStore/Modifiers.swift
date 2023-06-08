//
//  Modifiers.swift
//  SneakerStore
//
//  Created by A M on 05.06.2023.
//

import SwiftUI

struct NavBar: ViewModifier {
    func body(content: Content) -> some View {
        content
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color(red: 0.965, green: 0.965, blue: 0.965), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
    }
}

struct BlackButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .font(.system(size: 17))
            .fontWeight(.semibold)
            .frame(width: 358, height: 54)
            .background(.black)
            .cornerRadius(100)
            .padding(.bottom, 13)
    }
}


extension View {
    func navBarMod() -> some View {
        modifier(NavBar())
    }
    
    func blackButtonMod() -> some View {
        modifier(BlackButton())
    }
}


extension UINavigationController {
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        navigationBar.topItem?.backButtonDisplayMode = .minimal
    }
}


let lightGray = Color(red: 0.965, green: 0.965, blue: 0.965)

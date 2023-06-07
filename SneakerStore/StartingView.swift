//
//  StartingView.swift
//  SneakerStore
//
//  Created by A M on 06.06.2023.
//

import SwiftUI

extension UINavigationController {
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        navigationBar.topItem?.backButtonDisplayMode = .minimal
    }
}

struct WelcomeView: View {
    @Binding var isLoggedOut: Bool

    var body: some View {
        NavigationStack {
            VStack {
                Image("bg")
                
                HStack {
                    Image("shoes2")
                        .padding(.top, -28)
                    Image("shoes1")
                        .padding(.top, -200)
                }
                Spacer()
                
                Text("Welcome to the biggest sneakers store app")
                    .font(.system(size: 28))
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                ZStack {
                    RoundedRectangle(cornerRadius: 100)
                        .padding(.horizontal)
                        .padding(.vertical, 24)
                    
                    
                    NavigationLink(destination: RegistrationView(isLoggedOut: $isLoggedOut)) {
                        Text("Sign Up")
                            .font(.system(size: 17))
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                    }
                }
                
                NavigationLink(destination: AuthorizationView(isLoggedOut: $isLoggedOut)) {
                    Text("I already have an account")
                        .font(.system(size: 17))
                        .fontWeight(.semibold)
                        .padding(.bottom, 74)
                }
            }
            .ignoresSafeArea()
        }
    }
}

struct RegistrationView: View {
    @State private var registrationSuccess = false
    @State private var username = ""
    @State private var password = ""
    @State private var repassword = ""
    @State private var showError = false
    
    @Binding var isLoggedOut: Bool
    
    var body: some View {
        NavigationStack {
            VStack {
                
                VStack(spacing: 16){
                    ZStack {
                        RoundedRectangle(cornerRadius: 4)
                            .frame(height: 48)
                            .foregroundColor(lightGray)
                        TextField("Username", text: $username)
                            .padding(.leading)
                    }
                    .padding(.top, 62)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 4)
                            .frame(height: 48)
                            .foregroundColor(lightGray)
                        SecureField("Password", text: $password)
                            .padding(.leading)
                    }
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 4)
                            .frame(height: 48) 
                            .foregroundColor(lightGray)
                        SecureField("Repeat password", text: $repassword)
                            .padding(.leading)
                    }
                }
                .padding()
                
                Spacer()
                
                Button("Sign Up") {
                    UserManager.shared.registerUser(username: username, password: password)
                    if password == repassword {
                        registrationSuccess = true
                    } else {
                        showError = true
                    }
                }
                .blackButtonMod()
                .alert("Password does not match", isPresented: $showError) {
                    Button("OK", role: .cancel) { }
                }

                NavigationLink(destination: MenuView(isLoggedOut: $isLoggedOut), isActive: $registrationSuccess, label: { EmptyView() })
            }
            
            .navigationTitle("New User")
        }
    }
}

struct AuthorizationView: View {
    @State private var isLoggedIn = false
    @State var username = ""
    @State var password = ""
    @State private var showError = false
    
    @Binding var isLoggedOut: Bool

    
    var body: some View {        
        NavigationStack {
            VStack {
                
                VStack(spacing: 16){
                    ZStack {
                        RoundedRectangle(cornerRadius: 4)
                            .frame(height: 48)
                            .foregroundColor(lightGray)
                        TextField("Username", text: $username)
                            .padding(.leading)
                    }
                    .padding(.top, 62)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 4)
                            .frame(height: 48)
                            .foregroundColor(lightGray)
                        SecureField("Password", text: $password)
                            .padding(.leading)
                    }
                }
                .padding()
                
                Spacer()
                
                
                Button("Sign In ") {
                    if UserManager.shared.authorizeUser(username: username, password: password) {
                        isLoggedIn = true
                        UserManager.shared.printRegisteredUsers()
                    } else {
                        showError = true
                    }
                }
                .blackButtonMod()
                .alert("Incorrect username or password", isPresented: $showError) {
                    Button("OK", role: .cancel) {}
                }
                
                NavigationLink(destination: MenuView(isLoggedOut: $isLoggedOut), isActive: $isLoggedIn, label: { EmptyView() })
            }
            
            .navigationTitle("Welcome back!")
        }
    }
}

//struct StartingView_Previews: PreviewProvider {
//    static var previews: some View {
//        WelcomeView()
//    }
//}

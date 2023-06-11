//
//  ContentView.swift
//  SneakerStore
//
//  Created by A M on 03.06.2023.
//

import SwiftUI

struct ContentView: View {

    var body: some View {
        OnboardingView()
    }
}

struct MenuView: View {
    @StateObject private var cart = Cart()
    @StateObject private var userManager = UserManager()
    @StateObject private var orderHistory = OrderHistory()

    var body: some View {
        TabView {
            CatalogView(cart: cart)
                .tabItem {
                    Label("Catalog", systemImage: "house")
                }
            
            CartView(cart: cart, singleOrder: SingleOrder(orderHistory: orderHistory), orderHistory: orderHistory)
                .tabItem {
                    Label("Cart", systemImage: "cart")
                }
            
            ProfileView(userManager: userManager, cart: cart, singleOrder: SingleOrder(orderHistory: orderHistory), orderHistory: orderHistory)
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct CatalogView: View {
    @ObservedObject var cart: Cart
    let columns = [GridItem(.fixed(174), spacing: 10), GridItem(.fixed(174))]
    
    @State private var tappedProducts: Set<UUID> = []

    
    var body: some View {
        NavigationStack {
            ZStack {
                lightGray
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(productsData, id: \.self) { i in
                            ZStack {
                                RoundedRectangle(cornerRadius: 4)
                                .foregroundColor(.white)
                                .frame(width: 174, height: 292)
                            
                                VStack {
                                    i.image
                                        .background(.white)
                                
                                    Group {
                                        Text("\(i.name)")
                                            .font(.system(size: 13))
                                            .fontWeight(.semibold)
                                        
                                        Text("\(i.description)")
                                            .font(.system(size: 12))
                                            .foregroundColor(Color(red: 0.557, green: 0.557, blue: 0.576))
                                        
                                        Text("$ \(i.price)")
                                            .font(.system(size: 12))
                                            .fontWeight(.semibold)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading, 4)
                                    .padding(.bottom, 1)
                                
                                    
                                    Button(action: {
                                        if tappedProducts.contains(i.id) {
                                            tappedProducts.remove(i.id)
                                            cart.removeAllFromCart(i)
                                        } else {
                                            tappedProducts.insert(i.id)
                                            cart.addToCart(i)
                                        }
                                    }) {
                                        Text(tappedProducts.contains(i.id) && cart.products.keys.contains(i) ? "Remove" : "Add to cart")
                                            .foregroundColor(.white)
                                            .font(.system(size: 15))
                                            .frame(width: 166, height: 40)
                                            .background(tappedProducts.contains(i.id) && cart.products.keys.contains(i) ? Color(red: 0, green: 0, blue: 0, opacity: 0.7) : Color.black)
                                            .cornerRadius(100)
                                            .padding(.horizontal, 4)
                                            .padding(.bottom, 10)
                                    }


                                }
                            }
                        }
                    }
                    .padding(.top, 20)
                }
                .navigationTitle("Hello, Sneakerhead!")
                .navBarMod()
            }
        }
    }
}


struct CartView: View {
    @ObservedObject var cart: Cart
    @ObservedObject var singleOrder: SingleOrder
    @ObservedObject var orderHistory: OrderHistory
    @State private var showAlert = false
    @State private var showModal = false
    
    var body: some View {
        
        if cart.products.isEmpty {
            EmptyCartView()
        } else {
            
            NavigationStack {
                ZStack {
                    lightGray
                    
                    VStack {
                        List {
                            ForEach(Array(cart.products.keys), id: \.self) { i in
                                Section {
                                    HStack {
                                        i.image
                                            .frame(width: 140, height: 140)
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 10)
                                        
                                        VStack {
                                            Group {
                                                Text("\(i.name)")
                                                    .font(.system(size: 13))
                                                    .fontWeight(.semibold)
                                                
                                                Text("\(i.description)")
                                                    .font(.system(size: 12))
                                                    .foregroundColor(Color(red: 0.557, green: 0.557, blue: 0.576))
                                                
                                                Text("$ \(i.price)")
                                                    .font(.system(size: 12))
                                                    .fontWeight(.semibold)
                                            }
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding(.bottom, 1)
                                            
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 100)
                                                    .frame(width: 166, height: 36)
                                                
                                                HStack {
                                                    Button {
                                                        cart.removeFromCart(i)
                                                    } label: {
                                                        Image("minus")
                                                    }
                                                    .buttonStyle(BorderlessButtonStyle())
                                                    
                                                    Text("\(cart.products[i] ?? 0)")
                                                        .font(.system(size: 15))
                                                        .padding(.horizontal, 13)
                                                    
                                                    Button {
                                                        cart.addToCart(i)
                                                    } label: {
                                                        Image("plus")
                                                    }
                                                    .buttonStyle(BorderlessButtonStyle())
                                                    
                                                }
                                                .foregroundColor(.white)
                                            }
                                        }
                                    }
                                }
                            }
                            .onDelete { indexSet in
                                let products = Array(cart.products.keys)
                                let product = products[indexSet.first!]
                                cart.removeAllFromCart(product)
                            }
                            
                            HStack {
                                Text("\(cart.totalQuantity) items: Total (including Delivery)")
                                Spacer()
                                Text("$\(cart.totalPrice)")
                                    .fontWeight(.semibold)
                            }
                            .font(.system(size: 13))
                        }
                        .listStyle(.grouped)
                        .background(lightGray)
                        .scrollContentBackground(.hidden)
                        
                        
                        
                        Button("Confirm Order") {
                            showAlert = true
                        }
                        .blackButtonMod()
                        .alert(isPresented: $showAlert) {
                            Alert(
                                title: Text("Proceed with payment"),
                                message: Text("Are you sure you want to confirm?"),
                                primaryButton: .default(Text("Confirm").foregroundColor(.black)) {
                                    showModal = true
                                    singleOrder.addToSingleOrderAll(from: cart)
                                    let order = Order(name: "Example Order", date: Date(), numberOfItems: singleOrder.totalQuantity, price: singleOrder.totalPrice)

                                    orderHistory.addToOrderHistory(order)
                                },
                                secondaryButton: .cancel(Text("Cancel").foregroundColor(.black))
                            )
                        }
                        .sheet(isPresented: $showModal) {
                            ModalView(isPresented: $showModal, cart: cart)
                        }
                    }
                    .navigationTitle("Cart")
                    .navBarMod()
                }
            }
        }
    }
}

struct EmptyCartView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                lightGray

                VStack {
                    Image("bg")

                    Spacer()
                }

                VStack(spacing: 16) {
                    Text("Cart is empty")
                        .font(.system(size: 28))
                        .fontWeight(.semibold)
                    Text("Find interesting models in the Catalog.")
                        .font(.system(size: 17))
                }
            }
            .ignoresSafeArea()
            .navigationTitle("Cart")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ModalView: View {
    @Binding var isPresented: Bool
    @ObservedObject var cart: Cart
    
    var body: some View {
        ZStack {
            lightGray
            
            VStack {
                HStack {
                    Image("modalbg")
                    Spacer()
                }
                Spacer()
            }
            
            VStack {
                Spacer()
                
                Text("Your order is succesfully placed. Thanks!")
                    .font(.system(size: 28))
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                
                Button("Get back to shopping") {
                    isPresented = false
                    cart.products.removeAll()
                }
                .blackButtonMod()
            }
        }
    }
}

struct ProfileView: View {
    @ObservedObject var userManager: UserManager
    @ObservedObject var cart: Cart
    @ObservedObject var singleOrder: SingleOrder
    @ObservedObject var orderHistory: OrderHistory
    
    @State private var isLoggedOut = false

    @State private var signOut = false
    @State private var shoeSize = 44
    @State private var newShoeSize = Int()
    
    @State private var newUsername = ""
    @State private var newPassword = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                lightGray
                
                VStack {
                    List {
                        Section {
                            NavigationLink("Account Information") {
                                if let users = userManager.retrieveUserData() {
                                    ForEach(users, id: \.username) { user in
                                        VStack {
                                            
                                            VStack(spacing: 16){
                                                ZStack {
                                                    RoundedRectangle(cornerRadius: 4)
                                                        .frame(height: 48)
                                                        .foregroundColor(lightGray)
//
                                                    TextField("\(user.username)", text: $newUsername)
                                                        .padding(.leading)
//                                                        .onAppear {
//                                                            Text("\(newUsername)")
//                                                        }
                                                }
                                                .padding(.top, 62)
                                                
                                                ZStack {
                                                    RoundedRectangle(cornerRadius: 4)
                                                        .frame(height: 48)
                                                        .foregroundColor(lightGray)
//                                                    SecureField("Password", text: user.password)
//                                                        .padding(.leading)
//                                                    Text("\(user.password)")
                                                    TextField("\(user.password)", text: $newPassword)
                                                        .padding(.leading)
//                                                        .onAppear {
//                                                            Text("\(newPassword)")
//                                                        }

                                                }
                                                
//                                                ZStack {
//                                                    RoundedRectangle(cornerRadius: 4)
//                                                        .frame(height: 48)
//                                                        .foregroundColor(lightGray)
//                                                    SecureField("Repeat password", text: $repassword)
//                                                        .padding(.leading)
//                                                }
                                            }
                                            .padding()
                                            
                                            Spacer()
//
                                            Button("Save changes") {
                                                userManager.updateUserData(oldUsername: user.username, newUsername: newUsername, newPassword: newPassword)
                                            }
                                            .blackButtonMod()
//                                            .alert("Password does not match", isPresented: $showError) {
//                                                Button("OK", role: .cancel) { }
//                                            }
                                          
                                          
                                            
                                        }

                                    }
                                } else {
                                    Text("No user data found.")
                                }
                                
                            }
                        }
                        
                        Section {
                            NavigationLink("Order History") {
                                NavigationStack {
                                    List {
                                        ForEach(Array(orderHistory.orders.keys), id: \.self) { i in
                                            
                                            NavigationLink("Order") {
                                                List {
                                                    Section {
                                                        HStack {
                                                            Text("Ordered")
                                                            Spacer()
                                                            Text("\(i.date)")
                                                                .fontWeight(.semibold)
                                                        }
                                                    }
                                                    .font(.system(size: 13))
                                                    
                                                    Section {
                                                        HStack {
                                                            Text("\(singleOrder.totalQuantity) items: Total (Including Delivery)")
                                                            Spacer()
                                                            Text("$\(singleOrder.totalPrice)")
                                                                .fontWeight(.semibold)
                                                        }
                                                    }
                                                    .font(.system(size: 13))
                                                    
                                                    ForEach(Array(singleOrder.singleOrder.keys), id: \.self) { i in
                                                        Section {
                                                            HStack {
                                                                i.image
                                                                    .frame(width: 140, height: 140)
                                                                    .padding(.horizontal, 16)
                                                                    .padding(.vertical, 10)
                                                                
                                                                VStack {
                                                                    Group {
                                                                        Text("\(i.name)")
                                                                            .font(.system(size: 13))
                                                                            .fontWeight(.semibold)
                                                                        
                                                                        Text("\(i.description)")
                                                                            .font(.system(size: 12))
                                                                            .foregroundColor(Color(red: 0.557, green: 0.557, blue: 0.576))
                                                                        
                                                                        Text("$ \(i.price)")
                                                                            .font(.system(size: 12))
                                                                            .fontWeight(.semibold)
                                                                    }
                                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                                    .padding(.bottom, 1)
                                                                    
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                                .listMod()
                                            }
                                        }
                                        
                                    }
                                    .listMod()
                                    .navigationTitle("Order History")
                                }
                            }
                        }
                        
                        Section {
                            NavigationLink("Shoe size") {
                                NavigationStack {
                                    VStack {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 4)
                                                .frame(height: 48)
                                                .foregroundColor(lightGray)
                                            TextField("\(shoeSize)", value: $newShoeSize, format: .number)
                                                .padding(.leading)
                                        }
                                        .padding(.horizontal, 16)
                                        .padding(.top, 26)
                                      
                                        
                                        Spacer()
                                        
                                        Button("Save changes") {
                                            shoeSize = newShoeSize
                                        }
                                        .blackButtonMod()
                                        

                                    }
                                    
                                    .navigationTitle("Shoe Size")
                                    .navigationBarTitleDisplayMode(.inline)
                                }

                            }
                        }
                        
                        Section {
                            NavigationLink("How to know your shoe size?") {
                                
                            }
                            
                            NavigationLink("How to check the authenticity of the shoe?") {
                                
                            }
                        }
                    }
                    .listMod()
                    
                    Button("Sign Out") {
                        signOut = true
                    }
                    .blackButtonMod()
                    .alert(isPresented: $signOut) {
                        Alert(
                            title: Text("Are you sure you want to sign out?"),
                            primaryButton: .default(Text("Confirm").foregroundColor(.black)) {
                                isLoggedOut = true
                            },
                            secondaryButton: .cancel(Text("Cancel").foregroundColor(.black))
                        )
                    }
                    
                    NavigationLink(destination: WelcomeView(), isActive: $isLoggedOut, label: { EmptyView() })

                }
                .navigationTitle("Profile")
                .navBarMod()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        let userManager = UserManager()
//        ProfileView(userManager: userManager)
//    }
//}

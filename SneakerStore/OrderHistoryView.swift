////
////  OrderHistoryView.swift
////  SneakerStore
////
////  Created by Abai on 11.06.2023.
////
//
//import SwiftUI
//
//struct OrderHistoryView: View {
//    @ObservedObject var orderHistory: OrderHistory
//    @StateObject private var singleOrder = SingleOrder(orderHistory: OrderHistory())
//
//    var body: some View {
//        NavigationView {
//            List {
//                ForEach(Array(orderHistory.orders.keys), id: \.self) { order in
//                    NavigationLink(destination: OrderDetailView(order: order, singleOrder: singleOrder)) {
//                        Text("Order \(order.name)")
//                    }
//                }
//            }
//            .navigationTitle("Order History")
//        }
//    }
//}
//
//struct OrderDetailView: View {
//    let order: Order
//    @ObservedObject var singleOrder: SingleOrder
//
//    var body: some View {
//        List {
//            Section(header: Text("Ordered")) {
//                HStack {
//                    Text("Ordered")
//                    Spacer()
//                    Text("\(order.date)")
//                        .fontWeight(.semibold)
//                }
//            }
//            .font(.system(size: 13))
//
//            Section {
//                HStack {
//                    Text("\(singleOrder.totalQuantity) items: Total (Including Delivery)")
//                    Spacer()
//                    Text("$\(singleOrder.totalPrice)")
//                        .fontWeight(.semibold)
//                }
//            }
//            .font(.system(size: 13))
//
//            ForEach(Array(singleOrder.singleOrder.keys), id: \.self) { product in
//                Section {
//                    HStack {
//                        product.image
//                            .frame(width: 140, height: 140)
//                            .padding(.horizontal, 16)
//                            .padding(.vertical, 10)
//
//                        VStack(alignment: .leading) {
//                            Text("\(product.name)")
//                                .font(.system(size: 13))
//                                .fontWeight(.semibold)
//
//                            Text("\(product.description)")
//                                .font(.system(size: 12))
//                                .foregroundColor(Color(red: 0.557, green: 0.557, blue: 0.576))
//
//                            Text("$ \(product.price)")
//                                .font(.system(size: 12))
//                                .fontWeight(.semibold)
//                        }
//                    }
//                }
//            }
//        }
//        .listMod()
//    }
//}

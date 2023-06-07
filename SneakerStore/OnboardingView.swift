//
//  OnboardingView.swift
//  SneakerStore
//
//  Created by A M on 08.06.2023.
//

import SwiftUI

struct OnboardingView: View {
    var body: some View {
        OB1()
    }
}

struct OB1: View {
    var body: some View {
        ZStack {
            VStack {
                ZStack {
                    HStack {
                        Image("ob2")
                        Spacer()
                    }
                    
                    HStack {
                        Spacer()
                        VStack {
                            Spacer()
                            Image("ob1")
                            Spacer()
                            Spacer()
                            Spacer()
                        }
                    }
                }
                
                Image("obbg1")
            }
            
            VStack {
                Spacer()
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                    
                    //                    .foregroundStyle(Color(red: 0, green: 0, blue: 0, opacity: 0.3))
                        .foregroundStyle(.regularMaterial)
                        .frame(height: 300)
                    VStack {
                        Text("Fast shipping")
                            .font(.system(size: 28))
                            .fontWeight(.semibold)
                            .padding(.bottom, 16)

                        
                        Text("Get all of your desired sneakers in one place.")
                            .font(.system(size: 17))
                            .padding(.bottom, 24)
                        
                        Button("Next") {}
                            .blackButtonMod()
                    }
                }
            }
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}

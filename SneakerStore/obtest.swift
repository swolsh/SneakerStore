//
//  obtest.swift
//  SneakerStore
//
//  Created by Abai on 08.06.2023.
//

import SwiftUI

struct Slide1View: View {
    var body: some View {
        VStack {
            Text("Welcome to Onboarding")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            Text("Slide 1")
                .font(.title)
                .padding()
        }
    }
}

struct Slide2View: View {
    var body: some View {
        VStack {
            Text("Slide 2")
                .font(.title)
                .padding()
        }
    }
}

struct Slide3View: View {
    var body: some View {
        VStack {
            Text("Slide 3")
                .font(.title)
                .padding()
            
            Button(action: {
                // Finish button action
                // You can perform any necessary tasks here
            }) {
                Text("Finish")
                    .font(.headline)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.green)
                    .cornerRadius(10)
            }
        }
    }
}

struct OnboardingView2: View {
    @State private var currentPageIndex = 0
    
    var body: some View {
        VStack {
            TabView(selection: $currentPageIndex) {
                Slide1View()
                    .tag(0)
                
                Slide2View()
                    .tag(1)
                
                Slide3View()
                    .tag(2)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
            
            // Page Control
            PageControl(numberOfPages: 3, currentPageIndex: $currentPageIndex)
                .padding(.top, 20)
        }
    }
}

struct PageControl: View {
    var numberOfPages: Int
    @Binding var currentPageIndex: Int
    
    var body: some View {
        HStack {
            ForEach(0..<numberOfPages) { index in
                Circle()
                    .frame(width: 10, height: 10)
                    .foregroundColor(currentPageIndex == index ? .blue : .gray)
            }
        }
    }
}

struct OnboardingView2_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView2()
    }
}

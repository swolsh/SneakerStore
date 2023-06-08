//
//  OnboardingView.swift
//  SneakerStore
//
//  Created by A M on 08.06.2023.
//

import SwiftUI

struct OnboardingView: View {
    @State private var currentPageIndex = 0
    
    var body: some View {
        TabView(selection: $currentPageIndex) {
            OnboardingStepView1(image1: Image("ob1"), image2: Image("ob2"), imageBG: Image("obbg1"), obButton: "Next")
                .tabItem {
                    Text("Slide 1")
                }

            OnboardingStepView2(image1: Image("ob3"), image2: Image("ob4"), imageBG: Image("obbg2"), obButton: "Next")
                .tabItem {
                    Text("Slide 2")
                }

            OnboardingStepView3(image1: Image("ob5"), image2: Image("ob6"), imageBG: Image("obbg3"), obButton: "Finish")
                .tabItem {
                    Text("Slide 3")
                }
        }
        .tabViewStyle(PageTabViewStyle())
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))
        .ignoresSafeArea()
    }
}

struct OnboardingStepView1: View {
    let image1: Image
    let image2: Image
    let imageBG: Image
    let obButton: String
    
    @State private var proceedToWelcomePage = false
    
    func backgroundView() -> some View {
        VStack {
            ZStack {
                HStack {
                    image2
                    Spacer()
                }
                
                HStack {
                    Spacer()
                    VStack {
                        Spacer()
                        image1
                        Spacer()
                        Spacer()
                        Spacer()
                    }
                }
            }
            
            imageBG
        }
    }
        
    var body: some View {
        NavigationStack {
            ZStack {
                backgroundView()
                
                VStack {
                    Spacer()
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundStyle(.regularMaterial)
                            .frame(height: 288)
                        VStack {
                            Text("Fast shipping")
                                .font(.system(size: 28))
                                .fontWeight(.semibold)
                                .padding(.bottom, 16)
                            
                            
                            Text("Get all of your desired sneakers in one place.")
                                .font(.system(size: 17))
                                .padding(.bottom, 24)
                            
                            //                        Button(obButton) {
                            //                            proceedToWelcomePage = true
                            //                        }
                            //                        .blackButtonMod()
                            
                            NavigationLink(destination: WelcomeView()) {
                                Text("Next")
                                    .blackButtonMod()
                            }
                            
                        }
                    }
                }
            }
        }
    }
}

struct OnboardingStepView2: View {
    let image1: Image
    let image2: Image
    let imageBG: Image
    let obButton: String
    
    @State private var obFinished = false
    
    var onBoardingBody: some View = OnboardingStepView1(image1: Image("ob3"), image2: Image("ob4"), imageBG: Image("obbg2"), obButton: "Next").body
    
    var body: some View {
        onBoardingBody
        
    }
}

struct OnboardingStepView3: View {
    let image1: Image
    let image2: Image
    let imageBG: Image
    let obButton: String
    
    @State private var obFinished = false
    
    var onBoardingBody: some View = OnboardingStepView1(image1: Image("ob5"), image2: Image("ob6"), imageBG: Image("obbg3"), obButton: "Finish").body
    
    var body: some View {
        onBoardingBody
    }
}


struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}

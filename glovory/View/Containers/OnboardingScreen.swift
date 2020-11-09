//
//  OnboardingScreen.swift
//  glovory
//
//  Created by AlbertStanley on 01/11/20.
//

import SwiftUI

struct OnboardingScreen: View {
    @StateObject private var viewModel = OnboardingViewModel()
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                VStack {
                    Spacer().frame(height : 140)
                    Text("Increment").font(.system(size: 64)).fontWeight(.semibold
                    ).foregroundColor(.white)
                    Spacer()
                    Button(action : {}){
                        NavigationLink(destination: CreateActivity()) {
                            HStack {
                                Spacer()
                                Image(systemName: "plus.circle").foregroundColor(.white)
                                Text("Create a challenge")
                                    .foregroundColor(.white)
                                Spacer()
                            }
                        }
                    }.padding()
                    .buttonStyle(PrimaryButtonStyle())
                    Button(action: {}){
                        NavigationLink(destination: RegistrationScreen(viewModel: RegistrationViewModel(mode: .signup, isPushed: $viewModel.isPushed)), isActive : $viewModel.isPushed) {
                            Text("I already have an account").foregroundColor(.white)
                        }
                    }
                }.padding(.bottom, 15)
                .frame(maxWidth : .infinity, maxHeight: .infinity)
                .background(Image("pullup").resizable().aspectRatio(contentMode: .fill)
                                .frame(width : geo.size.width)
                                .overlay(Color.black.opacity(0.5))
                                .edgesIgnoringSafeArea(.all
                                )
                )
            }
        }
    }
}

struct OnboardingScreen_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingScreen()
    }
}

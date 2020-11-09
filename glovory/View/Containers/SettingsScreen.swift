//
//  SettingsScreen.swift
//  glovory
//
//  Created by AlbertStanley on 08/11/20.
//

import SwiftUI
import FirebaseAuth

struct SettingsScreen: View {
    @StateObject private var viewModel = SettingsViewModel()
    var body: some View {
        VStack {
            
            List(viewModel.itemViewModels.indices, id: \.self){
                index in
                let item = viewModel.item(at: index)
                Button(action: {
                    viewModel.tappedItem(at: index)
                }) {
                    HStack {
                        Image(systemName: item.iconName)
                        Text(item.title)
                    }
                }
            }.background(NavigationLink(
                destination: RegistrationScreen(viewModel: .init(mode: .signup, isPushed: $viewModel.registrationPushed)),
                isActive : $viewModel.registrationPushed
            ) {})
        }
        .navigationTitle(viewModel.title)
        .onAppear {
            viewModel.onAppear()
        }
    }
}

struct SettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScreen()
    }
}

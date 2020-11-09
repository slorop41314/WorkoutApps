//
//  RegistrationScreen.swift
//  glovory
//
//  Created by AlbertStanley on 08/11/20.
//

import SwiftUI

struct RegistrationScreen: View {
    @ObservedObject var viewModel: RegistrationViewModel
    
    var emailTextField: some View {
        TextField("Email", text: $viewModel.emailText).modifier(TextFieldCustomRoundedStyle())
    }
    
    var passwordTextField: some View {
        SecureField("Password", text: $viewModel.passwordText)
            .modifier(TextFieldCustomRoundedStyle())
    }
    
    var body: some View {
        VStack {
            Spacer()
            Text(viewModel.title).font(.largeTitle).fontWeight(.bold)
            Text(viewModel.subtitle).font(.title).fontWeight(.semibold)
            Spacer()
            emailTextField.padding(.bottom, 12)
            passwordTextField
            Button(action: {
                self.viewModel.tappedActionButton()
            }) {
                Text(viewModel.buttonTitle).frame(maxWidth: .infinity)
            }.padding().buttonStyle(PrimaryButtonStyle()).disabled(!viewModel.isValid)
            .opacity(viewModel.isValid ? 1 : 0.5)
            Spacer()
        }.padding()
    }
}

//struct RegistrationScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        RegistrationScreen(viewModel: .init(mode: .login, isPushed: <#Binding<Bool>#>))
//    }
//}

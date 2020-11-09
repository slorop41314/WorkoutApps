//
//  RegisterScreen.swift
//  glovory
//
//  Created by AlbertStanley on 29/10/20.
//

import SwiftUI

struct RemindScreen: View {
    var body: some View {
        VStack {
            Spacer()
//            DropDown()
            Spacer()
            VStack {
                Button(action : {}){
                    Text("Create reminder").frame(maxWidth : .infinity)
                }.buttonStyle(PrimaryButtonStyle())
                Button(action : {}){
                    Text("Skip for now")
                }
            }
        }
        .padding()
        .navigationBarTitle("Remind")
    }
}

struct RegisterScreen_Previews: PreviewProvider {
    static var previews: some View {
        RemindScreen()
    }
}

//
//  LoginScreen.swift
//  glovory
//
//  Created by AlbertStanley on 29/10/20.
//

import SwiftUI

struct CreateActivity: View {
    @StateObject var viewModel = CreateActivityViewModel()
    
    var dropDownList: some View {
        Group {
            DropDown(viewModel: $viewModel.exerciseDropdown)
            DropDown(viewModel: $viewModel.lengthDropdwon)
            DropDown(viewModel: $viewModel.increaseDropdown)
            DropDown(viewModel: $viewModel.startAmountDropdown)
        }
    }
    
    var mainContentView: some View {
        VStack {
            ScrollView {
                dropDownList
            }
            Spacer()
            Button(action : {
                viewModel.send(action: .createChallenge)
            }){
                Text("Create").frame(maxWidth: .infinity)
            }.buttonStyle(PrimaryButtonStyle())
        }
    }
    
    var body: some View {
        ZStack {
        if(viewModel.isLoading){
            ProgressView()
        }else {
            mainContentView
        }
        }
        .alert(isPresented: Binding<Bool>.constant($viewModel.error.wrappedValue != nil)){
            Alert(title: Text("Create avtivity error"), message: Text($viewModel.error.wrappedValue?.localizedDescription ?? ""), dismissButton: .default(Text("Close"), action: {
                self.viewModel.error = nil
            }))
        }
        .padding()
        .navigationBarBackButtonHidden(true)
        .navigationBarTitle("Create Activity")
    }
}


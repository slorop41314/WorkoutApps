//
//  ChallengeListScreen.swift
//  glovory
//
//  Created by AlbertStanley on 07/11/20.
//

import SwiftUI

struct ActivityListScreen: View {
    @StateObject private var viewModel = ActivityListViewModel()
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some View {
        if(viewModel.isLoading){
            ProgressView()
        }else if let error = viewModel.error {
            VStack {
                Text(error.localizedDescription)
                Button("Retry") {
                    viewModel.send(action: .retry)
                }
                .padding(10)
                .background(Rectangle().fill(Color.red).cornerRadius(5))
            }
        }else {
            mainContentView.onReceive(NotificationCenter.default.publisher(for: UIApplication.significantTimeChangeNotification)) {
                _ in
                viewModel.send(action: .timeChange)
            }
        }
    }
    
    var mainContentView: some View {
        ScrollView {
            VStack {
                LazyVGrid(columns: [.init(.flexible(), spacing: 20),.init(.flexible(), spacing: 20)]) {
                    ForEach(viewModel.itemViewModels, id: \.id) {
                        vm in ActivityItemView(vm: vm)
                        
                    }
                }
                .padding(10)
                Spacer()
            }
        }
        .sheet(isPresented: $viewModel.showingModal, content: {
            NavigationView {
                CreateActivity()
            }.preferredColorScheme(isDarkMode ? .dark : .light)
        })
        .navigationBarItems(trailing: Button(action: {
            viewModel.send(action: .create)
        }){
            Image(systemName: "plus.circle").imageScale(.large)
        })
        .navigationTitle(viewModel.title)
    }
}


struct ChallengeListScreen_Previews: PreviewProvider {
    static var previews: some View {
        ActivityListScreen()
    }
}

//
//  SettingViewModel.swift
//  glovory
//
//  Created by AlbertStanley on 08/11/20.
//

import Combine
import SwiftUI
import FirebaseAuth

class SettingsViewModel: ObservableObject {
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    @Published private(set) var itemViewModels: [SettingsItemViewModel] = []
    
    @Published var registrationPushed = false
    
    private var cancellables: [AnyCancellable] = []
    
    private let userService: UserServicesProtocol
    
    let title = "Settings"
    
    init(userService: UserServicesProtocol = UserServices()) {
        self.userService = userService
    }
    
    func item(at index: Int) -> SettingsItemViewModel {
        itemViewModels[index]
    }
    
    func tappedItem(at index: Int) {
        switch itemViewModels[index].type {
        case .mode:
            isDarkMode = !isDarkMode
            buildItems()
        case .account:
            guard userService.currentUser?.email == nil else {return}
            registrationPushed = true
        case .logout:
            userService.logout().sink {
                completion in
                switch completion {
                case .finished: break
                case let .failure(error):
                    print(error.localizedDescription)
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
        default :
            break
        }
    }
    
    private func buildItems() {
        itemViewModels = [
            .init(title: userService.currentUser?.email ?? "Create account", iconName: "person.circle", type: .account),
            .init(title: "Switch mode", iconName: "lightbulb", type: .mode),
            .init(title: "Privacy Policy", iconName: "shield", type: .privacy),
        ]
        if(userService.currentUser?.email != nil){
            itemViewModels += [.init(title: "Logout", iconName: "arrowshape.turn.up.backward", type: .logout)]
        }
    }
    
    
    func onAppear() {
        buildItems()
    }
}

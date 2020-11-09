//
//  BottomTab.swift
//  glovory
//
//  Created by AlbertStanley on 07/11/20.
//

import SwiftUI

struct BottomTab: View {
    @StateObject private var bottomTabViewModel = BottomTabViewModel()
    var body: some View {
        TabView(selection: $bottomTabViewModel.selectedTab) {
            ForEach(bottomTabViewModel.tabItemViewModels, id: \.self) {
                tab in
                tabView(for: tab.type)
                .tabItem {
                    Image(systemName: tab.imageName)
                    Text(tab.title)
                }.tag(tab.type)
            }
        }.accentColor(.primary)
    }
    
    @ViewBuilder
    func tabView(for tabItemType: TabItemViewModel.TabItemType) -> some View {
        switch tabItemType {
        case .log:
            Text("Log")
        case .challenge:
            NavigationView {
                ActivityListScreen()
            }
        case .settings:
            NavigationView {
            SettingsScreen()
            }
        }
    }
}

final class BottomTabViewModel: ObservableObject {
    
    @Published var selectedTab: TabItemViewModel.TabItemType = .challenge
    
    let tabItemViewModels = [
        TabItemViewModel(imageName: "book", title: "Activity Log", type: .log),
        TabItemViewModel(imageName: "list.bullet", title: "Challenges", type: .challenge),
        TabItemViewModel(imageName: "gear", title: "Settings", type: .settings)
    ]
}

struct TabItemViewModel: Hashable {
    let imageName: String
    let title: String
    let type: TabItemType
    
    enum TabItemType {
        case log
        case challenge
        case settings
    }
}

//
//  SettingsItemViewModel.swift
//  glovory
//
//  Created by AlbertStanley on 08/11/20.
//

import Foundation

extension SettingsViewModel {
    struct SettingsItemViewModel {
        let title: String
        let iconName: String
        let type: SettingsItemType
    }
    
    enum SettingsItemType {
        case account
        case mode
        case privacy
        case logout
    }
}

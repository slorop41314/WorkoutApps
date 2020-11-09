//
//  DropdownItemProtocol.swift
//  glovory
//
//  Created by AlbertStanley on 01/11/20.
//

import Foundation

protocol DropDownItemProtocol {
    var options: [DropDownOption] {get}
    var label: String {get}
    var value: String {get}
    var isSelected: Bool {get set}
    var selectedOption: DropDownOption {get set}
}

protocol DropDownOptionProtocol {
    var toDropDownOption: DropDownOption {get}
}

struct DropDownOption {
    enum DropDownOptionType {
        case text(String)
        case number(Int)
    }
    
    let type: DropDownOptionType
    let formatted: String
}

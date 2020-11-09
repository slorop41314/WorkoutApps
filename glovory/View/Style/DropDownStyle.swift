//
//  DropDownStyle.swift
//  glovory
//
//  Created by AlbertStanley on 01/11/20.
//

import SwiftUI

struct DropDownStyle: ButtonStyle {
    var fillColor : Color = .dropdownBackgroundColor
    func makeBody(configuration: Configuration) -> some View {
        return DropDownButton(configuration: configuration, fillColor: fillColor)
    }
    
    struct DropDownButton:View {
        let configuration: Configuration
        let fillColor : Color
        
        var body: some View {
            return configuration.label.padding(16)
                .background(RoundedRectangle(cornerRadius: 12.0).fill(
                    fillColor
                ))
                
        }
    }
}

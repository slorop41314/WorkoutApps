//
//  CustomButton.swift
//  glovory
//
//  Created by AlbertStanley on 29/10/20.
//

import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    var fillColor : Color = .buttonPrimaryColor
    func makeBody(configuration: Configuration) -> some View {
        return PrimaryButton(configuration: configuration, fillColor: fillColor)
    }
    
    struct PrimaryButton:View {
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

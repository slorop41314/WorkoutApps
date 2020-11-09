//
//  TextInputCustomRoundedStyle.swift
//  glovory
//
//  Created by AlbertStanley on 08/11/20.
//

import SwiftUI


struct TextFieldCustomRoundedStyle: ViewModifier {
    func body(content: Content)-> some View {
        return content
            .font(.system(size: 16, weight : .medium))
            .foregroundColor(Color(.systemGray4))
            .padding()
            .cornerRadius(5)
            .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.primary))
            .padding(.horizontal, 16)
    }
}

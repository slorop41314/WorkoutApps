//
//  DropDown.swift
//  glovory
//
//  Created by AlbertStanley on 01/11/20.
//

import SwiftUI

struct DropDown<T: DropDownItemProtocol> : View {
    @Binding var viewModel : T
    
    
    var actionSheet: ActionSheet {
        ActionSheet(title: Text("Select"), message: Text("Select option"), buttons: viewModel.options.map {
            option in
            return .default(Text(option.formatted)) {
                viewModel.selectedOption = option
            }
        })
    }
    
    var body: some View {
        VStack(alignment : .leading, spacing : 10) {
            Text(viewModel.label
            )
            Button(action : {
                viewModel.isSelected = true
            }) {
                HStack {
                    Text(viewModel.value)
                    Spacer()
                    Image(systemName: "chevron.down")                }
            }.buttonStyle(DropDownStyle())
        }
        .actionSheet(isPresented : $viewModel.isSelected) {
            actionSheet
        }
    }
}

//struct DropDown_Previews: PreviewProvider {
//    static var previews: some View {
//        DropDown()
//    }
//}

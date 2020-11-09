//
//  ActivityItemView.swift
//  glovory
//
//  Created by AlbertStanley on 08/11/20.
//

import SwiftUI


struct ActivityItemView: View {
    let vm : ActivityItemViewModel
    var titleRow: some View {
        HStack {
            Text(vm.title).font(.system(size: 24, weight: .bold))
            Spacer()
            Image(systemName: "trash").onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/, perform: {
                vm.send(action: .delete)
            })
        }
    }
    var dailyIncreaseRow: some View {
        HStack {
            Text(vm.dailyIncreaseText).font(.system(size: 24, weight: .bold))
            Spacer()
        }
    }
    
    var todayView: some View {
        VStack {
            Divider()
            Text(vm.todayTitle)
                .font(.title3)
                .fontWeight(.medium)
            Text(vm.todayRepTitle)
                .font(.system(size: 24, weight: .bold))
            Button(vm.isTodayComplete ? "Completed" : "Mark done"){
                vm.send(action: .toggleComplete)
            }
            .disabled(vm.isComplete)
            .padding(.vertical, 10)
            .padding(.horizontal, 15)
            .font(Font.caption.weight(.semibold))
            .background(vm.isTodayComplete ? Color.circleTrack :  Color.buttonPrimaryColor)
            .cornerRadius(8)
        }
    }
    
    var body: some View {
        HStack {
            Spacer()
            VStack(spacing: 25) {
                titleRow
                ProgressCircleView(viewModel: vm.progressItemViewModel)
                dailyIncreaseRow
                todayView
            }.padding(.vertical, 10)
            Spacer()
        }
        .background(Rectangle()
                        .fill(Color.buttonPrimaryColor).cornerRadius(5))
    }
}
//struct ActivityItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        ActivityItemView(vm: .init(Activity())
//    }
//}

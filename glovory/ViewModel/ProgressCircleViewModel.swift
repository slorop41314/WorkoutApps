//
//  ProgressCircleViewModel.swift
//  glovory
//
//  Created by AlbertStanley on 08/11/20.
//

import Foundation

struct ProgressCircleViewModel {
    let title: String
    let message: String
    let percentageComplete: Double
    var shouldShowTitle: Bool {
        percentageComplete <= 1
    }
}

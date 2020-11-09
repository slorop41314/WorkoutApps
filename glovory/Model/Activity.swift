//
//  Challenge.swift
//  glovory
//
//  Created by AlbertStanley on 05/11/20.
//

import Foundation
import FirebaseFirestoreSwift

struct Activity: Codable {
    @DocumentID var id: String?
    let exercise: String
    let startAmount : Int
    let increase: Int
    let length: Int
    let userId: String
    let startDate: Date
    let activitiesLog: [ActivityLog]
}

struct ActivityLog: Codable {
    let date: Date
    let isComplete: Bool
}

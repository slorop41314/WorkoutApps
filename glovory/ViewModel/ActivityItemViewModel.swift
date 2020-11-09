//
//  ActivityItemViewModel.swift
//  glovory
//
//  Created by AlbertStanley on 07/11/20.
//

import Foundation

struct ActivityItemViewModel: Identifiable {
    private let activity: Activity
    
    var id: String {
        activity.id!
    }
    
    var title : String {
        activity.exercise.capitalized
    }
    
    var progressItemViewModel: ProgressCircleViewModel {
        return .init(title: "Day", message: isComplete ? "Done" : "\(dayNumber)/\(activity.length)", percentageComplete: Double(daysFromStart) / Double(activity.length))
    }
    
    private var daysFromStart: Int {
        guard let daysFromStart = Calendar.current.dateComponents([.day], from: activity.startDate, to: Date()).day else {
            return 0
        }
        return abs(daysFromStart)
    }
    
    private var dayNumber: Int {
        daysFromStart + 1
    }
    
    var isComplete: Bool {
        daysFromStart - activity.length >= 0
    }
    
    var statusText: String {
        
        return isComplete ? "Done" : "Day \(dayNumber) of \(activity.length)"
    }
    
    var dailyIncreaseText: String {
        "+ \(activity.increase) daily"
    }
    
    private let onDelete : (String) -> Void
    private let onToggleComplete : (String, [ActivityLog]) -> Void
    
    let todayTitle = "Today"
    
    var todayRepTitle: String {
        let repNumber = activity.startAmount + (daysFromStart * activity.increase)
        let exercise : String
        if repNumber == 1 {
            var activityExercise = activity.exercise
            activityExercise.removeLast()
            exercise = activityExercise
        }else {
            exercise = activity.exercise
        }
        return isComplete ? "Completed" : "\(repNumber) " + exercise
    }
    
    var shouldShowTodayView: Bool {
        !isComplete
    }
    
    var isTodayComplete: Bool {
        let today = Calendar.current.startOfDay(for: Date())
        return activity.activitiesLog.first(where: { $0.date == today })?.isComplete == true
    }
    
    init(_ activity: Activity, onDelete: @escaping (String) -> Void, onToggleComplete: @escaping (String, [ActivityLog]) -> Void) {
        self.activity = activity
        self.onDelete = onDelete
        self.onToggleComplete = onToggleComplete
    }
    
    func send(action: Action) {
        guard let id = activity.id else {return}
        switch action {
        case .delete:
            onDelete(id)
        case .toggleComplete:
            let today = Calendar.current.startOfDay(for: Date())
            let log = activity.activitiesLog.map { log -> ActivityLog in
                if today == log.date {
                    return .init(date: today, isComplete : !log.isComplete)
                }else {
                    return log
                }
            }
            onToggleComplete(id, log)
        }
    }
}

extension ActivityItemViewModel {
    enum Action {
        case delete
        case toggleComplete
    }
}

//
//  CreateActivityViewModel.swift
//  glovory
//
//  Created by AlbertStanley on 01/11/20.
//

import SwiftUI
import Combine

typealias UserId = String
class CreateActivityViewModel: ObservableObject {
    @Published var exerciseDropdown = ActivityPartViewModel(type: .exercise)
    @Published var increaseDropdown = ActivityPartViewModel(type: .increase)
    @Published var lengthDropdwon = ActivityPartViewModel(type: .length)
    @Published var startAmountDropdown = ActivityPartViewModel(type: .startAmount)
    
    @Published var error: IncrementError?
    @Published var isLoading = false
    
    private let userService : UserServicesProtocol
    private let activityServices : ActivityServicesProtocol
    
    private var cancellables: [AnyCancellable] = []
    
    init(userService : UserServicesProtocol = UserServices(), activityServices : ActivityServicesProtocol = ActivityServices()) {
        self.userService = userService
        self.activityServices = activityServices
    }
    
    enum Action {
        case createChallenge
    }
    
    func send(action: Action) {
        switch action {
        case .createChallenge:
            isLoading = true
            currentUserId().flatMap {
                userId -> AnyPublisher<Void, IncrementError> in
                return self.createActivity(userId: userId)
            }
                .sink { completion in
                    self.isLoading = false
                switch completion {
                case let .failure(error) :
                    self.error = error
                case .finished:
                    print("Finished")
                }
            } receiveValue: { _ in
                print("succcess ")
            }.store(in : &cancellables)
            
        }
    }
    
    private func createActivity(userId: UserId) -> AnyPublisher<Void, IncrementError> {
        guard let exercise = exerciseDropdown.text,
              let startAmount = startAmountDropdown.number,
              let length = lengthDropdwon.number,
              let increase = increaseDropdown.number
              else {
            return Fail(error: .default(description: "Parsing error")).eraseToAnyPublisher()
              }
        
        let startDate = Calendar.current.startOfDay(for: Date())
        let activity = Activity(exercise: exercise, startAmount: startAmount, increase: increase, length: length, userId: userId, startDate: startDate, activitiesLog: (0..<length).compactMap {
            dayNum in
            if let dateForDayNum = Calendar.current.date(byAdding: .day, value: dayNum, to: startDate) {
                return .init(date: dateForDayNum, isComplete: false)
            } else {
                return nil
            }
        }
        )
        return activityServices.create(activity).eraseToAnyPublisher()
    }
    
    private func currentUserId() -> AnyPublisher<UserId, IncrementError> {
        return userService.currentUserPublisher().flatMap {
            user -> AnyPublisher<UserId,IncrementError>
            in if let userId = user?.uid {
                return Just(userId)
                    .setFailureType(to: IncrementError.self
                    )
                    .eraseToAnyPublisher()
            }else {
                return self.userService.signInAnonymously().map { $0.uid }.eraseToAnyPublisher()
                
            }
        }.eraseToAnyPublisher()
    }
}

extension CreateActivityViewModel {
    struct ActivityPartViewModel: DropDownItemProtocol {
        var selectedOption: DropDownOption
        
        var options: [DropDownOption]
        
        var label: String {
            type.rawValue
        }
        
        var value: String {
            selectedOption.formatted
        }
        
        var isSelected: Bool = false
        
        private let type: ActivityPartType
        
        init(type: ActivityPartType) {
            switch type {
            case .exercise:
                self.options = exerciseOption.allCases.map { $0.toDropDownOption }
            case .startAmount:
                self.options = startAmountOption.allCases.map { $0.toDropDownOption }
            case .increase:
                self.options = increaseOption.allCases.map { $0.toDropDownOption }
            case .length:
                self.options = lengthOption.allCases.map { $0.toDropDownOption }
            }
            self.type = type
            self.selectedOption = options.first!
        }
        
        enum ActivityPartType: String, CaseIterable {
            case exercise = "Exercise"
            case startAmount = "Start Amount"
            case increase = "Daily Increase"
            case length = "Challenge Length"
        }
        
        enum exerciseOption: String, CaseIterable, DropDownOptionProtocol {
            var toDropDownOption: DropDownOption {
                .init(type: .text(rawValue), formatted: rawValue.capitalized)
            }
            case pullups
            case pushups
            case situps
        }
        
        enum startAmountOption: Int,CaseIterable, DropDownOptionProtocol {
            var toDropDownOption: DropDownOption {
                .init(type: .number(rawValue), formatted:"\(rawValue)")
            }
            case one = 1, two, three, four, five
        }
        
        enum increaseOption: Int, CaseIterable, DropDownOptionProtocol {
            var toDropDownOption: DropDownOption {
                .init(type: .number(rawValue), formatted:"+ \(rawValue)")
            }
            case one = 1, two, three, four, five
        }
        
        enum lengthOption: Int, CaseIterable, DropDownOptionProtocol {
            var toDropDownOption: DropDownOption {
                .init(type: .number(rawValue), formatted:"\(rawValue) days")
            }
            case seven = 7, fourteen = 14, twentyOne = 21, twentyEight = 28
            
        }
    }
}

extension CreateActivityViewModel.ActivityPartViewModel {
    
    var text: String? {
        if case let .text(text) = selectedOption.type {
            return text
        }
        return nil
    }
    
    var number: Int? {
        if case let .number(num) = selectedOption.type {
            return num
        }
        return nil
    }
}


//
//  ChallengeListViewModel.swift
//  glovory
//
//  Created by AlbertStanley on 07/11/20.
//

import Combine

final class ActivityListViewModel: ObservableObject {
    private let userService: UserServicesProtocol
    private let activityService: ActivityServicesProtocol
    private var cancelables: [AnyCancellable] = []
    @Published private(set) var itemViewModels: [ActivityItemViewModel] = []
    @Published private(set) var error: IncrementError?
    @Published private(set) var isLoading = false
    @Published var showingModal = false
    
    let title: String = "Activity"
    
    init(userService: UserServicesProtocol = UserServices(), activityService: ActivityServicesProtocol = ActivityServices()) {
        self.userService = userService
        self.activityService = activityService
        observeActivity()
    }
    
    enum Action {
        case retry
        case create
        case timeChange
    }
    
    func send(action: Action) {
        switch action {
        case .retry:
            observeActivity()
        case .create:
            showingModal.toggle()
        case .timeChange:
            cancelables.removeAll()
            observeActivity()
        }
    }
    
    private func observeActivity() {
        isLoading = true
        userService.currentUserPublisher().compactMap {
            $0?.uid
        }.flatMap {
            userId -> AnyPublisher<[Activity], IncrementError> in
            return self.activityService.observeActivity(userId: userId)
        }.sink { [weak self] completion in
            guard let self = self else {return}
            self.isLoading = false
            switch completion {
            case .finished:
                print("FInished")
            case let .failure(error):
                self.error = error
            }
        } receiveValue: { [weak self] activities in
            guard let self = self else {return}
            self.isLoading = false
            self.error = nil
            self.showingModal = false
            self.itemViewModels = activities.map { activity in
                .init (
                    activity,
                    onDelete: {[weak self] id in self?.deleteActivity(id)},
                    onToggleComplete: {[weak self] id, activitiesLog in self?.updateActivity(id: id, activityLog: activitiesLog)}
                )
            }
        }.store(in: &cancelables)
    }
    
    private func deleteActivity(_ activityId: String) {
        activityService.deleteActivity(activityId).sink {
            completion in
            switch completion {
            case let .failure(error):
                print(error.localizedDescription)
            case .finished:
                break
            }
        } receiveValue: { _ in }
        .store(in: &cancelables)
    }
    
    private func updateActivity(id: String, activityLog: [ActivityLog]) {
        activityService.updateActivity(id, activitiesLog: activityLog).sink {
            completion in
            switch completion {
            case let .failure(error):
                print(error.localizedDescription)
            case .finished:
                break
            }
        } receiveValue: { _ in }
        .store(in: &cancelables)
    }
}

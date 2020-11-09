//
//  ChallengeServices.swift
//  glovory
//
//  Created by AlbertStanley on 05/11/20.
//

import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift


protocol ActivityServicesProtocol {
    func create(_ activity: Activity) -> AnyPublisher<Void, IncrementError>
    func observeActivity(userId : UserId) -> AnyPublisher<[Activity], IncrementError>
    func deleteActivity(_ challengeId : String) -> AnyPublisher<Void, IncrementError>
    func updateActivity(_ activityId : String, activitiesLog: [ActivityLog]) -> AnyPublisher<Void, IncrementError>
}

final class ActivityServices: ActivityServicesProtocol {
    func updateActivity(_ activityId: String, activitiesLog: [ActivityLog]) -> AnyPublisher<Void, IncrementError> {
        return Future<Void, IncrementError> {
            promise in
            self.db.collection("activity").document(activityId).updateData(["activitiesLog" : activitiesLog.map {
                return ["date": $0.date, "isComplete" : $0.isComplete]
            }]) {
                error in
                if let error = error {
                    return promise(.failure(.default(description: error.localizedDescription)))
                }
                return promise(.success(()))
            }
        }.eraseToAnyPublisher()
    }
    
    private let db = Firestore.firestore()
    
    func deleteActivity(_ challengeId: String) -> AnyPublisher<Void, IncrementError> {
        return Future<Void, IncrementError> {
            promise in
            self.db.collection("activity").document(challengeId).delete {
                error in
                if let error = error {
                    return promise(.failure(.default(description: error.localizedDescription)))
                }
                return promise(.success(()))
            }
        }.eraseToAnyPublisher()
    }
    
    func create(_ activity: Activity) -> AnyPublisher<Void, IncrementError> {
        return Future<Void, IncrementError> {
            promise in
            do {
                _ = try self.db.collection("activity").addDocument(from : activity) {
                    error in
                    if let error = error {
                        promise(.failure(.default(description: error.localizedDescription)))
                    }else {
                        promise(.success(()))
                    }
                }
            }catch {
                promise(.failure(.default()))
            }
        }.eraseToAnyPublisher()
    }
    
    func observeActivity(userId: UserId) -> AnyPublisher<[Activity], IncrementError> {
        let query = db.collection("activity").whereField("userId", isEqualTo: userId).order(by: "startDate", descending: true)
        return Publishers.QuerySnapshotPublisher(query: query).flatMap {
            snapshot -> AnyPublisher<[Activity], IncrementError> in
            do {
                let activity = try snapshot.documents.compactMap {
                    try $0.data(as: Activity.self)
                }
                return Just(activity).setFailureType(to: IncrementError.self).eraseToAnyPublisher()
            }catch {
                return Fail(error: .default(description: "Parsing error")).eraseToAnyPublisher()
            }
        }.eraseToAnyPublisher()
    }
    
}

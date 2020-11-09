//
//  UserServices.swift
//  glovory
//
//  Created by AlbertStanley on 03/11/20.
//

import FirebaseAuth
import Combine

protocol UserServicesProtocol {
    var currentUser: User? {get}
    func currentUserPublisher() -> AnyPublisher<User?, Never>
    func signInAnonymously() -> AnyPublisher<User, IncrementError>
    func signIn(email: String, password: String) -> AnyPublisher<Void, IncrementError>
    func observeAuthChanges() -> AnyPublisher<User?, Never>
    func linkAccount(email: String, password: String) -> AnyPublisher<Void, IncrementError>
    func logout() -> AnyPublisher<Void, IncrementError>
}

class UserServices: UserServicesProtocol {
    
    func signIn(email: String, password: String) -> AnyPublisher<Void, IncrementError> {
        return Future<Void, IncrementError> {
            promise in
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                if let error = error {
                    promise(.failure(.default(description: error.localizedDescription)))
                }else {
                    promise(.success(()))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    
    func logout() -> AnyPublisher<Void, IncrementError> {
        return Future<Void, IncrementError> {
            promise in
            do {
                try Auth.auth().signOut()
                promise(.success(()))
            } catch {
                promise(.failure(.default(description: error.localizedDescription)))
            }
        }.eraseToAnyPublisher()
    }
    
    var currentUser = Auth.auth().currentUser
    
    func linkAccount(email: String, password: String) -> AnyPublisher<Void, IncrementError> {
        let emailCredential = EmailAuthProvider.credential(withEmail: email, password: password)
        return Future<Void, IncrementError> {
            promise in
            Auth.auth().currentUser?.link(with: emailCredential, completion: { (result, error) in
                if let error = error {
                    return promise(.failure(.default(description: error.localizedDescription)))
                }else if let user = result?.user{
                    return Auth.auth().updateCurrentUser(user) {
                        error in
                        if let error = error {
                            return  promise(.failure(.default(description: error.localizedDescription)))
                        } else {
                            return promise(.success(()))
                        }
                    }
                }
            })
        }.eraseToAnyPublisher()
    }
    
    func observeAuthChanges() -> AnyPublisher<User?, Never> {
        Publishers.AuthPublisher().eraseToAnyPublisher()
    }
    
    func currentUserPublisher() -> AnyPublisher<User?, Never> {
        Just(Auth.auth().currentUser).eraseToAnyPublisher()
    }
    
    func signInAnonymously() -> AnyPublisher<User, IncrementError> {
        return Future<User, IncrementError> {
            promise in Auth.auth().signInAnonymously { (result, err) in
                if let error = err {
                    return promise(.failure(.auth(description: error.localizedDescription)))
                } else if let user = result?.user {
                    return promise(.success(user))
                }
                
            }
        }.eraseToAnyPublisher()
    }
    
    
}

//
//  RegistrationViewModel.swift
//  glovory
//
//  Created by AlbertStanley on 08/11/20.
//

import Combine
import SwiftUI

class RegistrationViewModel: ObservableObject {
    @Published var emailText = ""
    @Published var passwordText = ""
    @Published var isValid = false
    @Binding var isPushed: Bool
    private var cancellables: [AnyCancellable] = []
    private let userService: UserServicesProtocol
    
    private let mode: Mode
    
    init(mode: Mode, userService: UserServicesProtocol = UserServices(), isPushed: Binding<Bool>) {
        self.mode = mode
        self.userService = userService
        self._isPushed = isPushed
        
        Publishers.CombineLatest($emailText, $passwordText).map { [weak self] email, password in
            return self?.isValidEmail(email) == true && self?.isValidPassword(password) == true
        }.assign(to: &$isValid)
    }
    
    var title: String {
        switch mode {
        case .login:
            return "Welcome back"
        case .signup:
            return "Create account"
        }
    }
    
    var subtitle: String {
        switch mode {
        case .login:
            return "Login with email"
        case .signup:
            return "Register with email"
        }
    }
    
    var buttonTitle: String {
        switch mode {
        case .login:
            return "Login"
        case .signup:
            return "Create account"
        }
    }
    
    func tappedActionButton() {
        switch mode {
        case .login:
            userService.signIn(email: emailText, password: passwordText).sink {
                completion in
                switch completion {
                case .finished: break
                case let .failure(error):
                    print(error.localizedDescription)
                }
            } receiveValue: {_ in}
            .store(in: &cancellables)
        case .signup:
            userService.linkAccount(email: emailText, password: passwordText).sink {
                [weak self] completion in
                guard let self = self else {return}
                switch completion {
                case .finished:
                    self.isPushed = false
                    print("finished")
                case let .failure(error):
                    print(error.localizedDescription)
                }
            } receiveValue: {_ in}
            .store(in: &cancellables)
        }
    }
}

extension RegistrationViewModel {
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

            let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email) && email.count > 6
    }
    func isValidPassword(_ password: String) -> Bool {
        return password.count > 6
    }
}

extension RegistrationViewModel {
    enum Mode {
        case login
        case signup
    }
}

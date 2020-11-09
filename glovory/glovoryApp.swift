//
//  glovoryApp.swift
//  glovory
//
//  Created by AlbertStanley on 29/10/20.
//

import SwiftUI
import Firebase

@main
struct glovoryApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var appState = AppState()
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some Scene {
        WindowGroup {
            if appState.isLoggedIn {
                BottomTab().preferredColorScheme(isDarkMode ? .dark : .light)
            }else {
                ContentView()
            }
        }
    }
}

class AppDelegate: NSObject,UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

class AppState: ObservableObject {
    @Published private(set) var isLoggedIn = false
    
    private let userService: UserServicesProtocol
    
    init(userService :UserServicesProtocol =  UserServices()) {
        self.userService = userService
        userService.observeAuthChanges()
            .map {
                $0 != nil
            }
            .assign(to: &$isLoggedIn)
    }
}

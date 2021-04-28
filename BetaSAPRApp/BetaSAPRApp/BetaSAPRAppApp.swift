//
//  BetaSAPRAppApp.swift
//  BetaSAPRApp
//
//  Created by Alex Hernandez on 3/23/21.
//

import SwiftUI
import Firebase

@main
struct BetaSAPRAppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject private var timeToLeaveSettings = TimeToLeaveSettings()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(timeToLeaveSettings)
        }
    }
}

class AppDelegate : NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
         
    }
}

//
//  AppDelegate.swift
//  CatchTheCat
//
//  Created by Almir Khialov on 09.09.2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func reloadAppForNewLanguage() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateInitialViewController()
        window?.rootViewController = initialViewController
        window?.makeKeyAndVisible()
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Handle application going inactive
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Handle application entering background
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Handle application entering foreground
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart paused tasks
    }
}

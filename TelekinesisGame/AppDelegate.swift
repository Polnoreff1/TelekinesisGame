//
//  AppDelegate.swift
//  TelekinesisGame
//
//  Created by Andrei Versta on 24/3/25.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = LoaderViewControllerMia(isInitial: false)
        window?.makeKeyAndVisible()
        return true
    }
}

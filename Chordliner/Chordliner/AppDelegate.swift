//
//  AppDelegate.swift
//  Chordliner
//
//  Created on 2020/06/19.
//  Copyright © 2020 SotaIshino All rights reserved.
//

import UIKit

//tableViewのtextLabel(仮)
var textArray: [String] = ["1:", "2:", "3:", "4:", "5:", "6:", "7:", "8:"]

//現在の値 = 初期値
var currentChordArray: [String] = ["A♭m", "B♭", "C", "E♭sus2", "A♭", "Ddim", "C", "end"]

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}


//
//  AppDelegate.swift
//  SantanderTap
//
//  Created by Pranjal Lamba on 18/02/20.
//  Copyright © 2020 IDmission. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

     var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        if let userDefaults = UserDefaults(suiteName: "group.com.idmission.santap") {
            userDefaults.set("DEV2", forKey: "SanTap_URL")
            userDefaults.synchronize()
        }
      
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

    
    open var receivedUrl:URL?

    internal func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool{

        receivedUrl = url
        //You need to alter this navigation to match your app requirement so that you get a reference to your previous view..
        window?.rootViewController?.performSegue(withIdentifier: "toDeepLink", sender: nil)
        return true
    }

}


//
//  AppDelegate.swift
//  ios-ableton-controller
//
//  Created by Kevin Rupper on 5/2/17.
//  Copyright © 2017 Guerrilla Dev. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {}

    func applicationDidEnterBackground(_ application: UIApplication) {
//        SocketManager.sharedInstance.closeConnection()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {}

    func applicationDidBecomeActive(_ application: UIApplication) {
//        SocketManager.sharedInstance.establishConnection()
    }

    func applicationWillTerminate(_ application: UIApplication) {}

}


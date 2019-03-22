//
//  AppDelegate.swift
//  PurdueClass
//
//  Created by Keafe Chen on 2019/2/6.
//  Copyright © 2019 Qifeng Chen. All rights reserved.
//

import UIKit
import AWSAuthCore
import AWSMobileClient
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var isInitialized = false;

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        tabbar()
        
        check()
        // Override point for customization after application launch.
        AWSDDLog.add(AWSDDTTYLogger.sharedInstance)
        AWSDDLog.sharedInstance.logLevel = .info
        
        return AWSMobileClient.sharedInstance().interceptApplication(
            application,
            didFinishLaunchingWithOptions: launchOptions)    }
    
    func tabbar(){
        UITabBar.appearance().barTintColor = UIColor.darkGray
        UITabBar.appearance().tintColor = UIColor.red
    }
    
    func check(){
        if UserDefaults.standard.value(forKey: "username") != nil{
            let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let vc = mainStoryboard.instantiateViewController(withIdentifier: "TabBarIdentifier") as UIViewController
            //let navVC = UINavigationController(rootViewController: vc)
            let share = UIApplication.shared.delegate as? AppDelegate
            share?.window?.rootViewController = vc //navVC
            share?.window?.makeKeyAndVisible()
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}


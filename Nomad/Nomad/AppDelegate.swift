//
//  AppDelegate.swift
//  Nomad
//
//  Created by Kristin Beese on 2/14/16.
//  Copyright © 2016 Team 9. All rights reserved.
//
//
// CS307 Project Nomad Sprint 1

// CS 307 Spring 2016

//hello

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate   {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // when application opens
        // bring user to home view controller
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        let navController = UINavigationController(rootViewController: HomeViewController())
        self.window?.rootViewController = navController
        
        // call operating system
        
        self.window?.makeKeyAndVisible()
        
        // print all trips to console that were stored on the disk
        
        print(Trip.loadAll())
        
        let navigationBarAppearace = UINavigationBar.appearance()
        
        navigationBarAppearace.tintColor = UIColor.whiteColor()
        navigationBarAppearace.barTintColor = UIColor(red: 0.4627, green: 0.8549, blue: 0.698, alpha: 1.0)
        
        navigationBarAppearace.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}


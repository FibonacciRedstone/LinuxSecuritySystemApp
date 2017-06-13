//
//  AppDelegate.swift
//  Security Access
//
//  Created by Owner on 6/8/17.
//  Copyright © 2017 FibonacciCorp. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var defaults = UserDefaults.standard
    
    //Customizeable Constants
    let screenSessionName = "securityScreen"
    let saveFileName = "securitySave.txt"
    let sensorFile = "motionSensor.py"
    let useCamera = false
    //Directory shared by both save file and sensor program
    var commonDirectoryPath = "/home/pi/"
    
    //User defaults
    var lastHostName = ""
    var currentUser = ""
    var currentPassword = ""
    var shouldAutoLogin = false
    var lastImageName = ""


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        if commonDirectoryPath.characters.last != "/"{
            commonDirectoryPath+="/"
        }
        
        loadData()
        print(lastImageName)
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        saveData()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        saveData()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        saveData()
    }
    
    func saveData(){
        defaults.set(lastHostName, forKey: "lastHost")
        defaults.set(currentUser, forKey: "currentUser")
        defaults.set(currentPassword, forKey: "currentPassword")
        defaults.set(shouldAutoLogin, forKey: "shouldAutoLogin")
        defaults.set(lastImageName, forKey: "lastImageName")
        
    }
    
    func emptyError(text : String = "") -> NSError{
        let userInfo: [AnyHashable : Any] =
            [
                NSLocalizedDescriptionKey :  NSLocalizedString("Warning Error", value: text, comment: "") ,
                NSLocalizedFailureReasonErrorKey : NSLocalizedString("Warning Error", value: text, comment: "")
        ]
        let error = NSError(domain: "Simple Error Domain", code: -1, userInfo: userInfo)
        return error
    }
    
    func loadData(){
        if let host = defaults.object(forKey: "lastHost") as? String{
            lastHostName = host
        }
        if let user = defaults.object(forKey: "currentUser") as? String{
            currentUser = user
        }
        if let pass = defaults.object(forKey: "currentPassword") as? String{
            currentPassword = pass
        }
        if let imageName = defaults.object(forKey: "lastImageName") as? String{
            lastImageName = imageName
        }
        shouldAutoLogin = defaults.bool(forKey: "shouldAutoLogin")
    }


}


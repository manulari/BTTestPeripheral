//
//  AppDelegate.swift
//  BluetoothTest
//
//  Created by Manu Eder on 22.03.20.
//  Copyright © 2020 Manu Eder. All rights reserved.
//

import UIKit
import os.log

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var logV = [LogLine]()
    
    var state = State(step: 0)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // load log and state
        if let sLog = loadLog() {
            logV = sLog
        }
        if let sState = loadState() {
            state = sState
        }
        
        
        
        
        
        
        return true
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
    
    
    
    func log(_ s: String) {
        logV.append(LogLine(line:s))
        if let vc = window?.rootViewController as? ViewController {
            vc.log(s)
        }
        saveLog()
    }
    
    
    static func formatD(_ date: Date) -> String {
        let dF = DateFormatter()
        dF.dateFormat = "dd HH:mm:ss"
        return dF.string(from: Date())
    }
    
    func saveState() {
        let archivedData = try! NSKeyedArchiver.archivedData(withRootObject: state, requiringSecureCoding: false)
        try! archivedData.write(to: State.ArchiveURL)
    }
    
    private func loadState() -> State? {
        if let archivedData = try? Data(contentsOf: State.ArchiveURL) {
            return (try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(archivedData)) as? State
        }
        return nil
    }
    
    private func saveLog() {
//        let archivedData = try! NSKeyedArchiver.archivedData(withRootObject: logV, requiringSecureCoding: false)
//        try! archivedData.write(to: LogLine.ArchiveURL)
        if let archivedData = try? NSKeyedArchiver.archivedData(withRootObject: logV, requiringSecureCoding: false) {
            do {
                try archivedData.write(to: LogLine.ArchiveURL)
            } catch {
                os_log("saving failed.1", log: OSLog.default, type: .debug)
            }
        } else {
            os_log("saving failed.2", log: OSLog.default, type: .debug)
        }
    }
    
    private func loadLog() -> [LogLine]? {
        //return NSKeyedUnarchiver.unarchiveObject(withFile: LogLine.ArchiveURL.path) as? [LogLine]
//        let archivedData = try! Data(contentsOf: LogLine.ArchiveURL)
//        return (try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(archivedData)) as? [LogLine]
        if let archivedData = try? Data(contentsOf: LogLine.ArchiveURL) {
            if let rv = (try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(archivedData)) as? [LogLine] {
                return rv
            } else {
                os_log("loading failed.", log: OSLog.default, type: .debug)
                return nil
            }
        } else {
            os_log("loading failed.", log: OSLog.default, type: .debug)
            return nil
        }
 
    }


}




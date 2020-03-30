//
//  AppDelegate.swift
//  BluetoothTest
//
//  Created by Manu Eder on 22.03.20.
//  Copyright © 2020 Manu Eder. All rights reserved.
//

import UIKit
import os.log
import CoreBluetooth

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CBCentralManagerDelegate {
    
    

    var window: UIWindow?
    
    var logV = [LogLine]()
    
    var state = State(step: 0, isOn: false)
    
    var centralManager : CBCentralManager?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        var restoringCM = false
        
        // load log and state
        if let sLog = loadLog() {
            logV = sLog
        }
        if let sState = loadState() {
            state = sState
        }
        
        
        // bluetooth
        
        if let restoredManagers: [String] = launchOptions?[UIApplication.LaunchOptionsKey.bluetoothCentrals] as? [String] {
            if restoredManagers.contains("centralManager") {
                restoringCM = true
                log("called with a to-be-restored centralManager")
            }
        }
        
        if(state.isOn) {
            log("creating CM object")
            centralManager = CBCentralManager(delegate: self, queue: nil, options: [CBCentralManagerOptionRestoreIdentifierKey: "centralManager"])
            log("created CM object")
        }
        
        
        return true
    }
    
    
    //MARK: CBCentralManagerDelegate
    
    let UUIDPeripheral = CBUUID(string: "C019")
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if ( central.state == CBManagerState.poweredOn ) {
            central.scanForPeripherals(withServices: [ UUIDPeripheral ], options: nil)
        }
        else {
            log("central manager not powered on")
        }
    }
    /*
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        <#code#>
    }
    
    
    
    func centralManager(_ central: CBCentralManager, didUpdateANCSAuthorizationFor peripheral: CBPeripheral) {
        <#code#>
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        <#code#>
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        <#code#>
    }
    
    func centralManager(_ central: CBCentralManager, connectionEventDidOccur event: CBConnectionEvent, for peripheral: CBPeripheral) {
        <#code#>
    }
    */
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        log("p: " + peripheral.identifier.uuidString  + " r: " + RSSI.stringValue)
    }
    
    func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {
        log("CM restored")
    }
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
        saveState()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        saveState()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        saveState()
    }
    
    
    
    func log(_ s: String) {
        let line = AppDelegate.formatD(Date()) + ":" + s
        logV.append(LogLine(line:line))
        if let vc = window?.rootViewController as? ViewController {
            vc.log(line)
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




//
//  ViewController.swift
//  BluetoothTest
//
//  Created by Manu Eder on 22.03.20.
//  Copyright © 2020 Manu Eder. All rights reserved.
//

import UIKit
import os.log

class ViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var textView: UITextView!
    
    var logV = [LogLine]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let sLog = loadLog() {
            logV = sLog
            
        }
        //print((logV.map { ll in ll.line }).joined(separator: "\n"))
        textView.text = (logV.map { ll in ll.line }).joined(separator: "\n") + "\n"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }

    private func saveLog() {
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
    
    @IBAction func pressLog(_ sender: UIButton) {
        log(formatD(Date()))
    }
    
    @IBAction func pressExit(_ sender: UIButton) {
        exit(0)
    }
    
    
    func log(_ s: String) {
        logV.append(LogLine(line:s))
        textView.text += s + "\n"
        saveLog()
    }
    
    
    private func formatD(_ date: Date) -> String {
        let dF = DateFormatter()
        dF.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dF.string(from: Date())
    }
    
    
}


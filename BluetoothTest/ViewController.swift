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
    
    var appDelegate: AppDelegate {
     return UIApplication.shared.delegate as! AppDelegate
    }
    var state: State {
        return appDelegate.state
    }
    
    //MARK: Outlets
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var clock: UILabel!
    @IBOutlet weak var stepL: UILabel!
    @IBOutlet weak var stepS: UIStepper!
    @IBOutlet weak var toggleB: UIButton!
    var clockTimer: Timer?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        textView.text = (appDelegate.logV.map { ll in ll.line }).joined(separator: "\n") + "\n"
        stepS.value = Double(state.step)
        stepL.text = String(state.step)
        toggleLabel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        clockTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.clock.text = AppDelegate.formatD(Date())
        }
        clockTimer!.fire()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        clockTimer?.invalidate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }


    @IBAction func changeStep(_ sender: UIStepper) {
        state.step = Int(sender.value)
        appDelegate.saveState()
        stepL.text = String(state.step)
    }

    @IBAction func toggleOn(_ sender: UIButton) {
        state.isOn = !state.isOn
        if (!state.isOn) {
            appDelegate.peripheralManager?.stopAdvertising()
            appDelegate.peripheralManager = nil
        }
        toggleLabel()
        appDelegate.saveState()
    }
    
    func toggleLabel() {
        toggleB.setTitle(state.isOn ? "stop" : "start", for: UIControl.State.normal)
    }
    
    @IBAction func pressLog(_ sender: UIButton) {
        appDelegate.log(AppDelegate.formatD(Date()))
    }
    
    func log(_ s: String) {
        textView?.text += s + "\n"
    }
    
    @IBAction func pressExit(_ sender: UIButton) {
        exit(0)
    }
    
    

    
    
}


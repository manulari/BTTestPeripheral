//
//  State.swift
//  BluetoothTest
//
//  Created by Manu Eder on 23.03.20.
//  Copyright © 2020 Manu Eder. All rights reserved.
//

import Foundation
import os.log

class State : NSObject, NSCoding {
    var step: Int
    var isOn: Bool
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("state")
    
    
    init(step: Int, isOn: Bool) {
        self.step = step
        self.isOn = isOn
    }
    
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(step, forKey: PropertyKey.step)
        aCoder.encode(isOn, forKey: PropertyKey.isOn)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let step = aDecoder.decodeInteger(forKey: PropertyKey.step)
        let isOn = aDecoder.decodeBool(forKey: PropertyKey.isOn)
        self.init(step: step, isOn: isOn)
    }
}


struct PropertyKey {
    static let line = "line"
    static let step = "step"
    static let isOn = "isOn"
}

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
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("state")
    
    
    init(step: Int) {
        self.step = step
    }
    
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(step, forKey: PropertyKey.step)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let aStep = aDecoder.decodeInteger(forKey: PropertyKey.step)
        self.init(step: aStep)
    }
}


struct PropertyKey {
    static let line = "line"
    static let step = "step"
}

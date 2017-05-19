//
//  OscInt32.swift
//  ios-ableton-controller
//
//  Created by Kevin Rupper on 18/3/17.
//  Copyright © 2017 Guerrilla Dev. All rights reserved.
//

import Foundation

public struct OscInt32 {

    let value:Int32
    
    init(value: Int32) {
       self.value = value.bigEndian
    }
}

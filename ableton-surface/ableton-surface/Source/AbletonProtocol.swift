//
//  AbletonProtocol.swift
//  ios-ableton-controller
//
//  Created by Kevin Rupper on 26/2/17.
//  Copyright © 2017 Guerrilla Dev. All rights reserved.
//

import Foundation

protocol AbletonProtocol {
    func didMatrixSizeChange(tracks: Int, clips: Int)
    func didClipSlotChange(track: Int, clip: Int, isRemoved: Int)
}

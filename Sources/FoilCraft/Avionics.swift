//
//  File.swift
//  
//
//  Created by Dennis Hernandez on 10/31/20.
//

import Foundation


enum channelKeys:UInt8 {
    case leftX
    case leftY
    case leftButton
    case rightX
    case rightY
    case rightButton
    case pot0
    case pot1
    case button0
    case button1
    case button2
    case button3
    case button4
    case button5
}

class Avionics:SerialDelegate {
    
    var channels: [UInt8] = Array(repeating: UInt8(0), count: 14)
    
    func receiveData(bytes: [UInt8]) {
        channels = bytes
        
    }
}

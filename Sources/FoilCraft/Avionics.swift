//
//  File.swift
//  
//
//  Created by Dennis Hernandez on 10/31/20.
//

import Foundation



enum channelKeys:Int {
    case leftX = 5
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
    var updateThread:Thread! = nil
    
    var freshChannelData: [UInt8] = Array(repeating: UInt8(0), count: 14)
    var currentChannelData: [UInt8] = Array(repeating: UInt8(0), count: 14)
    var staleChannelData: [[UInt8]] = []
    
    var throttle:Float = 0.0
    
    init(newThrottle: Float?) {
        if (newThrottle != nil) {throttle = newThrottle!}
        
        updateThread = Thread(){
            while true {
                self.update(newThrottle: self.throttle)
            }
        }
        
        updateThread.qualityOfService = .userInteractive
        updateThread.start()
        
    }
    
    func receiveData(bytes: [UInt8]) {
//        print(bytes)
        freshChannelData = bytes
        staleChannelData.insert(freshChannelData, at: 0)
        
        if (staleChannelData.count <= staleChannelDataCache)  {
            staleChannelData = staleChannelData.dropLast(0)
        }
        
        throttle = Float(freshChannelData[channelKeys.leftX.rawValue])
    }
    
    func update(newThrottle: Float?) {
        if (newThrottle != nil) {throttle = newThrottle!}
        //        let servo0 = Servo(thePWM: (pwms[0]?[.P18])!, theLocation: .RPI, theChannel: 0)
        let servo1 = Servo(thePWM: nil, theType: .Servo, theLocation: .PCA, theChannel: 0)
        let servo2 = Servo(thePWM: nil, theType: .Servo, theLocation: .PCA, theChannel: 14)
        let servo3 = Servo(thePWM: nil, theType: .ESC, theLocation: .PCA, theChannel: 15)
        
        //        servo0.speed(newSpeed: throttle)
        servo1.speed(newSpeed: throttle)
        servo2.speed(newSpeed: throttle)
        servo3.speed(newSpeed: throttle)
        
        print("Throttle: ",throttle)
    }
    
    
    
}

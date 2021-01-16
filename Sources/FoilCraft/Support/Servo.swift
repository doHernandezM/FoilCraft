//
//  File.swift
//  
//
//  Created by Dennis Hernandez on 1/14/21.
//

import Foundation
import SwiftyGPIO

// Initialize PWM
fileprivate let period = 2_000_000
let pwms = SwiftyGPIO.hardwarePWMs(for:.RaspberryPiPlusZero)!
var pwm0:PWMOutput? = nil
var pwm1:PWMOutput? = nil
fileprivate let rpiServoRange:[Float] = [40,98]

let pca9685 = PCA9685(supportedBoard: .RaspberryPiPlusZero)
fileprivate let pcaServoRange:[Float] = [632,1875]

class Servo {
    
    enum Location {
        case Arduino
        case RPI
        case PCA
    }
    
    var pwm:PWMOutput? = nil
    
    let location:Location?
    var channel:UInt8? = 0
    var speed:Float = 0
    
    init(thePWM: PWMOutput?, theLocation: Location, theChannel: UInt8?) {
        pwm = thePWM
        location = theLocation
        channel = theChannel
        
        startPWM()
    }
    
    func startPWM() {
        pwm?.initPWM()
    }
    static func startPCA() {
        pca9685.frequency = 50 // Hz
    }
    
    static func freePIPWM() -> PWMOutput? {
        if (pwm0 == nil) {
            pwm0 = (pwms[0]?[.P18])!
            return pwm0
        }
        
        if (pwm1 == nil) {
            pwm1 = (pwms[1]?[.P19])!
            return pwm1
        }
        return nil
    }
    
    func speed(newSpeed: Float) {
        speed = newSpeed
        var servoSteps:UInt16 = 0
        
        switch location {
        case .Arduino:
            print("Arduino")
        case .RPI:
            servoSteps = UInt16(map(value: speed, fromLow: 0, fromHigh: 100, toLow: rpiServoRange[0], toHigh: rpiServoRange[1]))
            pwm?.startPWM(period:period , duty: speed)
            print("RPI", speed, servoSteps)
        case .PCA:
            servoSteps = UInt16(map(value: speed, fromLow: 0, fromHigh: 100, toLow: pcaServoRange[0], toHigh: pcaServoRange[1]))
            pca9685.setChannel(channel!, onStep: 0, offStep: UInt16(servoSteps ) )
            print("PCA", speed, servoSteps, servoSteps)
        default:
            break
        }
    }
    
    func stop() {
        switch location {
        case .Arduino:
            print("Arduino")
        case .RPI:
            print("Arduino")
        case .PCA:
            print("Arduino")
        default:
            print("Arduino")
        }
    }
    
}

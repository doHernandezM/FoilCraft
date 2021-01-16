import Foundation

import SwiftyGPIO

#if os(Linux)
import Glibc
#else
import Darwin.C
#endif
import Foundation


var avionics = Avionics()
var serial = SerialController(serialDelegate: avionics)


///Setup Code
//public var writeBuffer = ""
////Start a thread for the castle. This is what manages all of the pins
//
var exit = false
////serial.receiveThread.start()
//

while(!exit){
    
    print("Send: ", terminator:" ")
    let input = readLine(strippingNewline: true)
    let throttle = Float(input ?? "0.0") ?? 0.0
    exit = (input=="x") ? true : false
    
    if !exit {
        let servo0 = Servo(thePWM: (pwms[0]?[.P18])!, theLocation: .RPI, theChannel: 0)
        let servo1 = Servo(thePWM: nil, theLocation: .PCA, theChannel: 0)
        let servo2 = Servo(thePWM: nil, theLocation: .PCA, theChannel: 15)
        let servo3 = Servo(thePWM: nil, theLocation: .PCA, theChannel: 7)
        
        
        servo0.speed(newSpeed: throttle)
        servo1.speed(newSpeed: throttle)
        servo2.speed(newSpeed: throttle)
        servo3.speed(newSpeed: throttle)
        
        //            sleep(1)
        
    }
}

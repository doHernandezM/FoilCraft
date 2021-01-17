import Foundation

import SwiftyGPIO

#if os(Linux)
import Glibc
#else
import Darwin.C
#endif
import Foundation


var avionics = Avionics(newThrottle: 0.0)
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
        avionics.update(newThrottle: throttle)
    }
}

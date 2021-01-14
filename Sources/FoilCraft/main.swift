import Foundation

import SwiftyGPIO

#if os(Linux)
import Glibc
#else
import Darwin.C
#endif
import Foundation

/*
var avionics = Avionics()
var serial = SerialController(serialDelegate: avionics)


///Setup Code
public var writeBuffer = ""
//Start a thread for the castle. This is what manages all of the pins

var exit = false
serial.receiveThread.start()

while(!exit){
    
    print("Send: ", terminator:" ")
    let input = readLine(strippingNewline: false)
    exit = (input=="exit\n") ? true : false
    
    if !exit {
        serial.uart.writeString(input!)
    }
}

 */



let uarts = SwiftyGPIO.UARTs(for:.RaspberryPi2)!
var uart = uarts[0]

uart.configureInterface(speed: .S115200, bitsPerChar: .Eight, stopBits: .One, parity: .None)

// Let's build a simple echo server, connect UART-TX(.P14) with UART-RX(.P15) and launch this program.
// What you type will be transmitted from the TX pin and received on the RX pin, so that you'll be able
// to verify that the data is transmitted correctly.
// Alternatively, cross connect two raspberrypis or a pi and a pc and you'll have a simple chat server.
//
print("Ready...")

let tRead = Thread(){
    while true {
        let s = uart.readData()
        print(s.count)
    }
}
tRead.start()

var exit = false

while(!exit){
    
    print("Send: ", terminator:" ")
    var input = readLine(strippingNewline: false)
    exit = (input=="exit\n") ? true : false
    
    if !exit {
        uart.writeString(input!)
    }
}

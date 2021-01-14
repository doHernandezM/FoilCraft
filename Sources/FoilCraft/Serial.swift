//
//  File.swift
//
//
//  Created by Dennis Hernandez on 6/15/20.
//

import Foundation
import SwiftyGPIO

public let debugMode = false

class SerialController {
    var delegate: SerialDelegate!
    let uarts = SwiftyGPIO.UARTs(for:.RaspberryPi3)!
    var uart:UARTInterface! = nil
    var receiveThread:Thread! = nil
    
    var receivedData: [String] = []
    
    init(serialDelegate: SerialDelegate) {
        
        uart = uarts[0]
        uart.configureInterface(speed: .S115200, bitsPerChar: .Eight, stopBits: .One, parity: .None)
        
        print("Serial Init")
        
        receiveThread = Thread(){
            while true {
                print("123")
                let receivedString = self.uart.readLine()
                
                serialDelegate.receiveData(data: receivedString)
                
                self.receivedData = [receivedString]
                
                print(":::" + receivedString, terminator: "")
            }
        }
        
        self.delegate = serialDelegate
        receiveThread.qualityOfService = .userInteractive
//        receiveThread.threadPriority = 1.0
        print("ABC")
        }
    
    func readLine() -> String {
        return self.uart.readLine()
    }
    
    func send(string:String) {
        uart.writeString(string)
    }
}

protocol SerialDelegate {
    
    func receiveData(data:String)
}

/*
 struct data_package {
     var leftX: UInt8 = 0
     var leftY: UInt8 = 0
     var leftA: UInt8 = 0
     var leftS: UInt8 = 0
     var leftD: UInt8 = 0
     var leftF: UInt8 = 0
     var leftG: UInt8 = 0
     var leftH: UInt8 = 0
     var leftJ: UInt8 = 0
     var leftK: UInt8 = 0
     var leftL: UInt8 = 0
     var leftZ: UInt8 = 0
     var leftQ: UInt8 = 0
     var leftC: UInt8 = 0

 }
 */

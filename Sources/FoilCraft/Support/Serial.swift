//
//  File.swift
//
//
//  Created by Dennis Hernandez on 6/15/20.
//

import Foundation
import SwiftSerial

public let debugMode = false
let portName = "/dev/serial0"

class SerialController {
    var delegate: SerialDelegate!
    var receiveThread:Thread! = nil
    var serialPort: SerialPort = SerialPort(path: portName)
    
    let cleanBytes: [UInt8] = [90,78,56,34,12,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    var dirtyBytes: [UInt8] = [90,78,56,34,12,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    var bytes: [UInt8] = [90,78,56,34,12,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    
    var byteOffset = -255
    
    init(serialDelegate: SerialDelegate) {
        serialPort = SerialPort(path: portName)
        delegate = serialDelegate
        startListening()
    }
    
    func startListening() {
        do {
            print("Attempting to open port: \(portName)")
            try serialPort.openPort()
            print("Serial port \(portName) opened successfully.")
            defer {
                //                serialPort.closePort() //Why no worky?
                print("¿Port Closed?")
            }
            
            serialPort.setSettings(receiveRate: .baud115200,
                                   transmitRate: .baud115200,
                                   minimumBytesToRead: dirtyBytes.count)
            
            //Run the serial port reading function in another thread
            receiveThread = Thread(){
                while true {
                    self.backgroundRead()
                }
            }
            receiveThread.qualityOfService = .userInteractive
            receiveThread.start()
            
            print("\nReady to send and receive messages in realtime!")
            
            
            
        } catch PortError.failedToOpen {
            print("Serial port \(portName) failed to open. You might need root permissions.")
        } catch {
            print("Error: \(error)")
        }
        
    }
    
    func backgroundRead() {
        while true{
            do{
                let count = dirtyBytes.count
                _ = try serialPort.readBytes(into: &dirtyBytes, size: count)
                if (dirtyBytes[0] != cleanBytes[0]){
                    shiftBytes()
                } else {
                    bytes = dirtyBytes
                }
                delegate.receiveData(bytes: bytes)
            } catch {
                print("Error: \(error)")
            }
        }
    }
    
    func shiftBytes() {
        for (i,_) in dirtyBytes.enumerated() {
            if bytesAligned(i: i, theBytes: dirtyBytes) {
                bytes = dirtyBytes.shift(withDistance: i)
                return
            }
        }
        
    }
    
    func bytesAligned(i: Int, theBytes:[UInt8]) -> Bool {
        byteOffset = i
        
        if (dirtyBytes[byteOffset] != cleanBytes[0]) {
        return false
        }
        
        byteOffset += 1
        if byteOffset > cleanBytes.count - 1 {byteOffset = 0}
        
        if (dirtyBytes[byteOffset] != cleanBytes[1]) {
        return false
        }
        
        byteOffset += 1
        if byteOffset > cleanBytes.count - 1 {byteOffset = 0}
        
        if (dirtyBytes[byteOffset] != cleanBytes[2]) {
        return false
        }
        
        byteOffset += 1
        if byteOffset > cleanBytes.count - 1 {byteOffset = 0}
        
        if (dirtyBytes[byteOffset] != cleanBytes[3]) {
        return false
        }
        
        byteOffset += 1
        if byteOffset > cleanBytes.count - 1 {byteOffset = 0}
        
        if (dirtyBytes[byteOffset] != cleanBytes[4]) {
        return false
        }
        
        return true
    }

}

protocol SerialDelegate {
    func receiveData(bytes:[UInt8])
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

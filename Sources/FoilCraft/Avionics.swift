//
//  File.swift
//  
//
//  Created by Dennis Hernandez on 10/31/20.
//

import Foundation

class Avionics:SerialDelegate {
    func receiveData(data: String) {
        print(data)
    }
}

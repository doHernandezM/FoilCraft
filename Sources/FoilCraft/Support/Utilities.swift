//
//  File.swift
//  
//
//  Created by Dennis Hernandez on 1/14/21.
//



import Foundation

extension Array {

    /**
     Returns a new array with the first elements up to specified distance being shifted to the end of the collection. If the distance is negative, returns a new array with the last elements up to the specified absolute distance being shifted to the beginning of the collection.

     If the absolute distance exceeds the number of elements in the array, the elements are not shifted.
     */
    func shift(withDistance distance: Int = 1) -> Array<Element> {
        let offsetIndex = distance >= 0 ?
            self.index(startIndex, offsetBy: distance, limitedBy: endIndex) :
            self.index(endIndex, offsetBy: distance, limitedBy: startIndex)

        guard let index = offsetIndex else { return self }
        return Array(self[index ..< endIndex] + self[startIndex ..< index])
    }

    /**
     Shifts the first elements up to specified distance to the end of the array. If the distance is negative, shifts the last elements up to the specified absolute distance to the beginning of the array.

     If the absolute distance exceeds the number of elements in the array, the elements are not shifted.
     */
    mutating func shiftInPlace(withDistance distance: Int = 1) {
        self = shift(withDistance: distance)
    }

}

/**
 Taken from Arduino: https://www.arduino.cc/reference/en/language/functions/math/map/
 Re-maps a number from one range to another. That is, a value of fromLow would get mapped to toLow, a value of fromHigh to toHigh, values in-between to values in-between, etc. Does not constrain values to within the range, because out-of-range values are sometimes intended and useful. The constrain() function may be used either before or after this function, if limits to the ranges are desired.
 */
func map(value:Float, fromLow:Float, fromHigh:Float, toLow:Float, toHigh:Float) -> Float {
    // 417 - 204 = 213
    let fromSize = fromHigh - fromLow
    // 2000 - 1000 = 1000
    let toSize = toHigh - toLow
    //(50 / 100) = .5
    let percentage = (value / fromSize)
    //.5 * 1000
    return (percentage * toSize) + toLow
}

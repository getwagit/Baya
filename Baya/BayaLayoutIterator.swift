//
// Copyright (c) 2016-2017 wag it GmbH.
// License: MIT
//

import Foundation
import UIKit

/**
    This iterator provides simple iterating loops which can be used to layout children.
*/
internal protocol BayaLayoutIterator {}

/**
    Default LayoutIterator implementation.
*/
internal extension BayaLayoutIterator {
    /**
        Basic iterator method that provides the previous and the current child to a closure.
     
        - Parameter elements: The elements to iterate on. Array will get mutated.
        - Parameter l: The closure which will receive the previous and the current child.
    */
    func iterate(_ elements: inout [BayaLayoutable], _ measures: [CGSize], l: (BayaLayoutable?, BayaLayoutable, CGSize) -> CGRect) {
        guard elements.count > 0 else {
            return
        }
        guard elements.count == measures.count else {
            return
        }
        for i in 0..<elements.count {
            let prevElement = i == 0 ? nil : elements[i - 1]
            let currentElement = elements[i]
            elements[i].layoutWith(frame: l(prevElement, currentElement,  measures[i]))
        }
    }
    
    /**
         Provide a cache of measurements and only measure items if necessary.
         Modifies the input array.
 
         - Parameter elements: The elements to measure. Array will be mutated.
         - Parameter cache: The previous measurements if available
         - Parameter size: The bas for the measurement
    */
    func measureIfNecessary(_ elements: inout [BayaLayoutable], cache: [CGSize], size: CGSize) -> [CGSize] {
        guard elements.count > cache.count else {
            return cache
        }
        var sizes = [CGSize](repeating: CGSize(), count: elements.count)
        guard elements.count > 0 else {
            return sizes
        }
        for i in 0..<elements.count {
            let cached: CGSize? = cache.count > i ? cache[i] : nil
            sizes[i] = cached ?? elements[i].sizeThatFitsWithMargins(size)
        }
        return sizes
    }

    /**
        Measures all elements while modifying the input array.
     
        - Parameter elements: The elements to measure. Array will be mutated.
        - Parameter size: The base for the measurement.
    */
    func measure(_ elements: inout [BayaLayoutable], size: CGSize) -> [CGSize] {
        var sizes = [CGSize](repeating: CGSize(), count: elements.count)
        guard elements.count > 0 else {
            return sizes
        }
        for i in 0..<elements.count {
            sizes[i] = elements[i].sizeThatFitsWithMargins(size)
        }
        return sizes
    }

    /**
        Remeasure the input size if necessary and add margins.
     
        - Parameter e2s: the input size that was already measured.
        - Parameter e2: the element. Will be modified if measurement is necessary.
        - Parameter size: the base size used for measurement if necessary.
    */
    func saveMeasure(e2s: CGSize?, e2: inout BayaLayoutable, size: CGSize) -> CGSize {
        return e2s ?? e2.sizeThatFitsWithMargins(size)
    }
}

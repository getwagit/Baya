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
    mutating func iterate(_ elements: inout [BayaLayoutable], _ measures: [CGSize], l: (BayaLayoutable?, inout BayaLayoutable, CGSize?) -> CGRect) {
        guard elements.count > 0 else {
            return
        }
        for i in 0..<elements.count { // Has to loop with i because of struct copies.
            let measure: CGSize? = measures.count > i ? measures[i] : nil
            elements[i].layoutWith(frame: l(i == 0 ? nil : elements[i - 1], &elements[i], measure))
        }
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
        return e2s?.addMargins(ofElement: e2) ??
            e2.sizeThatFitsWithMargins(size).addMargins(ofElement: e2)
    }
}

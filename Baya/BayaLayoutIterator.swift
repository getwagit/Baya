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
    mutating func iterate(_ elements: inout [BayaLayoutable], l: (BayaLayoutable?, BayaLayoutable) -> CGRect) {
        guard elements.count > 0 else {
            return
        }
        for i in 0..<elements.count { // Has to loop with i because of struct copies.
            elements[i].layoutWith(frame: l(i == 0 ? nil : elements[i - 1], elements[i]))
        }
    }
}

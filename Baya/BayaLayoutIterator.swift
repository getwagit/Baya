//
// Copyright (c) 2016-2017 wag it GmbH.
// License: MIT
//

import Foundation
import UIKit
import Oak

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
    mutating func iterate(_ elements: inout [Layoutable], l: (Layoutable?, Layoutable) -> CGRect) {
        guard elements.count > 0 else {
            Oak.i("Skipping layout because there are no elements iterate on")
            return
        }
        for i in 0..<elements.count { // Has to loop with i because of struct copies.
            elements[i].layoutWith(frame: l(i == 0 ? nil : elements[i - 1], elements[i]))
        }
    }
}

//
// Copyright (c) 2016-2017 wag it GmbH.
// License: MIT
//

import Foundation
import UIKit

/**
    Protocol for any layout.
*/
public protocol BayaLayout: BayaLayoutable {}

/**
    Methods just for the layout!
*/
public extension BayaLayout {
    /**
        Kick off the layout routine of the root element.
        Only call this method on the root element.
        Measures child layoutables but tries to keep them within the frame.
    */
    mutating public func startLayout(with frame: CGRect) {
        let origin = frame.origin
        let measuredSize = self.sizeThatFitsWithMargins(frame.size).addMargins(ofElement: self)
        let size = CGSize(
            width: min(frame.size.width, measuredSize.width),
            height: min(frame.size.height, measuredSize.height))
        self.layoutWith(frame: CGRect(
            origin: origin,
            size: size))
    }
}

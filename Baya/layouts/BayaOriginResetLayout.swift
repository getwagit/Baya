//
// Copyright (c) 2016-2017 wag it GmbH.
// License: MIT
//

import Foundation
import UIKit

/**
    Sets the origin of a given element to x: 0, y: 0. Handy when laying out views in deeper view hierarchies.
    Mirrors frame, layoutMargins and layoutModes from its child.
*/
public struct BayaOriginResetLayout: BayaLayout {
    public var layoutMargins: UIEdgeInsets {
        return element.layoutMargins
    }
    public var frame: CGRect {
        return element.frame
    }
    public var layoutModes: BayaLayoutOptions.Modes {
        return element.layoutModes
    }
    private var element: BayaLayoutable

    init(element: BayaLayoutable) {
        self.element = element
    }

    mutating public func layoutWith(frame: CGRect) {
        element.layoutWith(frame: CGRect(origin: CGPoint(), size: frame.size))
    }

    public mutating func sizeThatFits(_ size: CGSize) -> CGSize {
        return element.sizeThatFits(size)
    }
}

public extension BayaLayoutable {
    /// Lays out the element at the origin x: 0, y: 0, disregarding the origin of the given frame.
    /// - returns: A `BayaOriginResetLayout`.
    func layoutResettingOrigin() -> BayaLayout {
        return BayaOriginResetLayout(element: self)
    }
}

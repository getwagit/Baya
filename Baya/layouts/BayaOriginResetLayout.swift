//
// Copyright (c) 2016-2017 wag it GmbH.
// License: MIT
//

import Foundation
import UIKit

/**
    Sets the origin of a given element to x: 0, y: 0. Handy when laying out views in deeper view hierarchies.
*/
public struct BayaOriginResetLayout: BayaLayout {
    public var layoutMargins: UIEdgeInsets
    public var frame: CGRect

    private var element: BayaLayoutable

    init(
        element: BayaLayoutable,
        layoutMargins: UIEdgeInsets = UIEdgeInsets.zero) {
        self.element = element
        self.layoutMargins = layoutMargins
        self.frame = CGRect()
    }

    mutating public func layoutWith(frame: CGRect) {
        self.frame = CGRect(origin: CGPoint(), size: frame.size)
        element.layoutWith(frame: self.frame)
    }

    public mutating func sizeThatFits(_ size: CGSize) -> CGSize {
        let fit = element.sizeThatFitsWithMargins(size)
        return fit.addMargins(ofElement: element)
    }
}

public extension BayaLayoutable {
    func layoutResetOrigin(layoutMargins: UIEdgeInsets = UIEdgeInsets.zero) -> BayaLayout {
        return BayaOriginResetLayout(element: self, layoutMargins: layoutMargins)
    }
}

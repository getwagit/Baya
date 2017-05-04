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
    private var measure: CGSize?

    init(
        element: BayaLayoutable,
        layoutMargins: UIEdgeInsets = UIEdgeInsets.zero) {
        self.element = element
        self.layoutMargins = layoutMargins
        self.frame = CGRect()
    }

    mutating public func layoutWith(frame: CGRect) {
        self.frame = frame;
        let size = measure ?? element.sizeThatFitsWithMargins(frame.size)
        element.layoutWith(frame: CGRect(origin: CGPoint(), size: size))
    }

    public mutating func sizeThatFits(_ size: CGSize) -> CGSize {
        measure = element.sizeThatFitsWithMargins(size)
        return measure!.addMargins(ofElement: element)
    }
}

public extension BayaLayoutable {
    func layoutResetOrigin(layoutMargins: UIEdgeInsets = UIEdgeInsets.zero) -> BayaLayout {
        return BayaOriginResetLayout(element: self, layoutMargins: layoutMargins)
    }
}

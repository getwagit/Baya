//
// Copyright (c) 2016-2017 wag it GmbH.
// License: MIT
//

import Foundation
import UIKit

/**
    Wraps a Layoutable in order to modify its layout modes.
    Mirrors layout modes and frame from its child.
 */
public struct BayaMatchParentLayout: BayaLayout {
    public var bayaMargins: UIEdgeInsets {
        return element.bayaMargins
    }
    public var frame: CGRect {
        return element.frame;
    }
    public var bayaModes: BayaLayoutOptions.Modes = BayaLayoutOptions.Modes.default

    private var element: BayaLayoutable

    init(
        element: BayaLayoutable,
        bayaModes: BayaLayoutOptions.Modes) {
        self.element = element
        self.bayaModes = bayaModes
    }

    mutating public func layoutWith(frame: CGRect) {
        element.layoutWith(frame: frame)
    }

    public mutating func sizeThatFits(_ size: CGSize) -> CGSize {
        return element.sizeThatFits(size)
    }
}

public extension BayaLayoutable {
    /// Specifies that the element should fill its parent's width instead of using the measured width.
    /// - returns: A `BayaMatchParentLayout`.
    func layoutMatchingParentWidth() -> BayaLayout {
        return BayaMatchParentLayout(
            element: self,
            bayaModes: BayaLayoutOptions.Modes(
                width: .matchParent,
                height: self.bayaModes.height))
    }

    /// Specifies that the element should fill its parent's height instead of using the measured height.
    /// - returns: A `BayaMatchParentLayout`.
    func layoutMatchingParentHeight() -> BayaLayout {
        return BayaMatchParentLayout(
            element: self,
            bayaModes: BayaLayoutOptions.Modes(
                width: self.bayaModes.width,
                height: .matchParent))
    }

    /// Specifies that the element should fill its parent's size instead of using the measured size.
    /// - returns: A `BayaMatchParentLayout`.
    func layoutMatchingParent()
            -> BayaLayout {
        return BayaMatchParentLayout(
            element: self,
            bayaModes: BayaLayoutOptions.Modes(
                width: .matchParent,
                height: .matchParent))
    }
}

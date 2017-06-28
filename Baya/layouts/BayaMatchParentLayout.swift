//
// Copyright (c) 2016-2017 wag it GmbH.
// License: MIT
//

import Foundation
import UIKit

/**
    Wraps a Layoutable in order to modify its measures modes.
 */
public struct BayaMatchParentLayout: BayaLayout {
    public var layoutMargins: UIEdgeInsets {
        return element.layoutMargins
    }
    public var frame: CGRect {
        return element.frame;
    }
    public var measureModes: BayaMeasureModes = defaultMeasureModes

    private var element: BayaLayoutable

    init(
        element: BayaLayoutable,
        measureModes: BayaMeasureModes) {
        self.element = element
        self.measureModes = measureModes
    }

    mutating public func layoutWith(frame: CGRect) {
        element.layoutWith(frame: frame)
    }

    public mutating func sizeThatFits(_ size: CGSize) -> CGSize {
        return element.sizeThatFits(size)
    }
}

public extension BayaLayoutable {
    func layoutMatchingParentWidth() -> BayaLayout {
        return BayaMatchParentLayout(
            element: self,
            measureModes: BayaMeasureModes(
                width: .matchParent,
                height: .wrapContent))
    }

    func layoutMatchingParentHeight() -> BayaLayout {
        return BayaMatchParentLayout(
            element: self,
            measureModes: BayaMeasureModes(
                width: .wrapContent,
                height: .matchParent))
    }

    func layoutMatchingParent()
            -> BayaLayout {
        return BayaMatchParentLayout(
            element: self,
            measureModes: BayaMeasureModes(
                width: .matchParent,
                height: .matchParent))
    }
}

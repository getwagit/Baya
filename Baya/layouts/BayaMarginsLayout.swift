//
// Copyright (c) 2016-2017 wag it GmbH.
// License: MIT
//

import Foundation

/**
    This Layout should only be used on Layoutables whose margins cannot be controlled otherwise, 
    for example the root view of an UIViewController.
    Mirrors the child's layoutModes.
 */
internal struct BayaMarginsLayout: BayaLayout {
    public var layoutModes: BayaLayoutOptions.Modes {
        return element.layoutModes
    }
    public var layoutMargins: UIEdgeInsets
    public var frame: CGRect
    private var element: BayaLayoutable
    private var measure: CGSize?
    
    init(
        element: BayaLayoutable,
        layoutMargins: UIEdgeInsets) {
        self.element = element
        self.layoutMargins = layoutMargins
        self.frame = CGRect()
    }

    public mutating func layoutWith(frame: CGRect) {
        self.frame = frame
        element.layoutWith(frame: frame)
    }

    public mutating func sizeThatFits(_ size: CGSize) -> CGSize {
        measure = element.sizeThatFitsWithMargins(size)
        return measure!
    }
}

internal extension BayaLayoutable {
    func layoutWithMargins(layoutMargins: UIEdgeInsets) -> BayaMarginsLayout {
        return BayaMarginsLayout(
            element: self,
            layoutMargins: layoutMargins)
    }
}

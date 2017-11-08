//
// Copyright (c) 2016-2017 wag it GmbH.
// License: MIT
//

import Foundation

/**
    This Layout should only be used on Layoutables whose margins cannot be controlled otherwise, 
    for example the root view of an UIViewController.
    Mirrors the child's bayaModes and frame.
 */
public struct BayaMarginsLayout: BayaLayout {
    public var bayaModes: BayaLayoutOptions.Modes {
        return element.bayaModes
    }
    public var frame: CGRect {
        return element.frame
    }
    public var bayaMargins: UIEdgeInsets
    private var element: BayaLayoutable
    
    init(
        element: BayaLayoutable,
        bayaMargins: UIEdgeInsets) {
        self.element = element
        self.bayaMargins = bayaMargins
    }

    public mutating func layoutWith(frame: CGRect) {
        element.layoutWith(frame: frame)
    }

    public mutating func sizeThatFits(_ size: CGSize) -> CGSize {
        return element.sizeThatFitsWithMargins(size)
    }
}

public extension BayaLayoutable {
    /// Disregards the element's margins and substitutes them with the margins passed as parameter.
    /// - parameter bayaMargins: The layout's margins.
    /// - returns: A `BayaMarginsLayout`.
    func layoutWithMargins(bayaMargins: UIEdgeInsets) -> BayaMarginsLayout {
        return BayaMarginsLayout(
            element: self,
            bayaMargins: bayaMargins)
    }
}

extension UIViewController {
    /// Enables full control over the root view's margins by wrapping it in a `BayaMarginsLayout`.
    /// The `bayaMargins` of `UIViewController`s' root views are managed by the system, and cannot be changed.
    /// To prevent unwanted layout behavior, use this function.
    /// - parameter bayaMargins: The desired `bayaMargins` around the view.
    /// - returns: A `BayaMarginsLayout` containing the `UIViewController`'s root view.
    public func getRootViewAsLayoutable(with bayaMargins: UIEdgeInsets = UIEdgeInsets.zero) -> BayaLayoutable {
        return view.layoutWithMargins(bayaMargins: bayaMargins)
    }
}

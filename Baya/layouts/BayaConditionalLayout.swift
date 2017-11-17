//
// Copyright (c) 2017 wag it GmbH.
// License: MIT
//

import Foundation

/**
    A layout that skips the child element if a certain condition is met.
    In that case, size and margins are zero.
    Mirrors bayaModes but wraps the margins (in order to zero them out if the condition is not met)
*/
public struct BayaConditionalLayout: BayaLayout {
    public var bayaMargins = UIEdgeInsets.zero
    public var frame: CGRect
    public var bayaModes: BayaLayoutOptions.Modes {
        return element.bayaModes
    }
    private var element: BayaLayoutable
    private var measure: CGSize?
    private let condition: () -> Bool

    init(
        element: BayaLayoutable,
        condition: @escaping () -> Bool) {
        self.element = element
        self.condition = condition
        self.frame = CGRect()
    }

    public mutating func layoutWith(frame: CGRect) {
        self.frame = frame
        guard condition() else {
            return
        }
        let size = calculateSizeForLayout(forChild: &element, cachedSize: measure, ownSize: frame.size)
        let margins = element.bayaMargins
        element.layoutWith(frame: CGRect(
            x: frame.minX + margins.left,
            y: frame.minY + margins.top,
            width: size.width,
            height: size.height))
    }

    public mutating func sizeThatFits(_ size: CGSize) -> CGSize {
        guard condition() else {
            return CGSize()
        }
        measure = element.sizeThatFitsWithMargins(size)
        return measure?.addMargins(ofElement: element) ?? CGSize()
    }
}

public extension BayaLayoutable {
    /// The child element is measured and positioned only if the condition is met.
    /// Wraps the child element and its margins.
    /// Mirrors the modes.
    /// - parameter condition: Should return `true` if the layout should be executed.
    /// - returns: A `BayaConditionalLayout`.
    func layoutIf(condition: @escaping () -> Bool) -> BayaConditionalLayout {
        return BayaConditionalLayout(
            element: self, condition: condition)
    }
}

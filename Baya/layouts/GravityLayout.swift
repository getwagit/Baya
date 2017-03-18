//
// Copyright (c) 2016-2017 wag it GmbH.
// License: MIT
//

import Foundation
import UIKit
import Oak

/**
    Simple layout that positions one child according to its gravity.
*/
struct GravityLayout: BayaLayout {
    var layoutMargins: UIEdgeInsets
    var frame: CGRect

    private var element: BayaLayoutable
    private let gravity: (BayaLayoutOptions.Gravity.Horizontal, BayaLayoutOptions.Gravity.Vertical)

    init(
        element: BayaLayoutable,
        gravity: (BayaLayoutOptions.Gravity.Horizontal, BayaLayoutOptions.Gravity.Vertical),
        layoutMargins: UIEdgeInsets = UIEdgeInsets.zero) {
        self.element = element
        self.layoutMargins = layoutMargins
        self.gravity = gravity
        self.frame = CGRect()
    }

    mutating func layoutWith(frame: CGRect) {
        self.frame = frame
        let size = sizeThatFitsWithMargins(of: element, size: frame.size)
        var point = CGPoint()

        switch gravity.0 {
        case .left: point.x = frame.minX + element.layoutMargins.left
        case .center: point.x = frame.midX - (size.width * 0.5)
        case .right: point.x = frame.maxX - size.width - element.layoutMargins.right
        }

        switch gravity.1 {
        case .top: point.y = frame.minY + element.layoutMargins.top
        case .middle: point.y = frame.midY - (size.height * 0.5)
        case .bottom: point.y = frame.maxY - size.height - element.layoutMargins.bottom
        }

        element.layoutWith(frame: CGRect(
            origin: point,
            size: size))
    }

    func sizeThatFits(_ size: CGSize) -> CGSize {
        let fit = sizeThatFitsWithMargins(of: element, size: size)
        return addMargins(size: fit, element: element)
    }
}

// MARK: Gravity shortcuts

public extension BayaLayoutable {
    func gravitate(to horizontalGravity: LayoutOptions.Gravity.Horizontal) -> Layoutable {
        return GravityLayout(
            element: self,
            gravity: (horizontalGravity, .top))
    }

    func gravitate(to verticalGravity: LayoutOptions.Gravity.Vertical) -> Layoutable {
        return GravityLayout(
            element: self,
            gravity: (.left, verticalGravity))
    }

    func gravitate(
        horizontally horizontalGravity: LayoutOptions.Gravity.Horizontal,
        vertically verticalGravity: LayoutOptions.Gravity.Vertical) -> Layoutable {
        return GravityLayout(
            element: self,
            gravity: (horizontalGravity, verticalGravity))
    }
}

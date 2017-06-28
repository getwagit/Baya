//
// Copyright (c) 2016-2017 wag it GmbH.
// License: MIT
//

import Foundation
import UIKit

/**
    Simple layout that positions one child according to its gravity.
*/
public struct BayaGravityLayout: BayaLayout {
    public var layoutMargins: UIEdgeInsets
    public var frame: CGRect
    private var element: BayaLayoutable
    private var measure: CGSize?
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

    public mutating func layoutWith(frame: CGRect) {
        self.frame = frame
        let size = measure ?? element.sizeThatFitsWithMargins(frame.size)
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

    public mutating func sizeThatFits(_ size: CGSize) -> CGSize {
        measure = element.sizeThatFitsWithMargins(size)
        return measure!.addMargins(ofElement: element)
    }
}

public extension BayaLayoutable {
    func layoutGravitating(to horizontalGravity: BayaLayoutOptions.Gravity.Horizontal) -> BayaGravityLayout {
        return BayaGravityLayout(
            element: self,
            gravity: (horizontalGravity, .top))
    }

    func layoutGravitating(to verticalGravity: BayaLayoutOptions.Gravity.Vertical) -> BayaGravityLayout {
        return BayaGravityLayout(
            element: self,
            gravity: (.left, verticalGravity))
    }

    func layoutGravitating(
        horizontally horizontalGravity: BayaLayoutOptions.Gravity.Horizontal,
        vertically verticalGravity: BayaLayoutOptions.Gravity.Vertical,
        layoutMargins: UIEdgeInsets = UIEdgeInsets.zero)
            -> BayaGravityLayout {
        return BayaGravityLayout(
            element: self,
            gravity: (horizontalGravity, verticalGravity),
            layoutMargins: layoutMargins)
    }
}

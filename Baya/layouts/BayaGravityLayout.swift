//
// Copyright (c) 2016-2017 wag it GmbH.
// License: MIT
//

import Foundation
import UIKit

/**
    Simple layout that positions one child according to its gravity.
    It also assumes layout mode .matchParent for gravitating axis.
*/
public struct BayaGravityLayout: BayaLayout {
    public var layoutMargins: UIEdgeInsets = UIEdgeInsets.zero
    public var frame: CGRect
    public let layoutModes: BayaLayoutOptions.Modes
    private var element: BayaLayoutable
    private var measure: CGSize?
    private let horizontalGravity: BayaLayoutOptions.Gravity.Horizontal?
    private let verticalGravity: BayaLayoutOptions.Gravity.Vertical?

    init(
        element: BayaLayoutable,
        horizontalGravity: BayaLayoutOptions.Gravity.Horizontal?,
        verticalGravity: BayaLayoutOptions.Gravity.Vertical?) {
        self.element = element
        self.horizontalGravity = horizontalGravity
        self.verticalGravity = verticalGravity
        self.frame = CGRect()
        self.layoutModes = BayaLayoutOptions.Modes(
            width: horizontalGravity != nil ? .matchParent : element.layoutModes.width,
            height: verticalGravity != nil ? .matchParent : element.layoutModes.height)
    }

    public mutating func layoutWith(frame: CGRect) {
        self.frame = frame
        let size = calculateSizeForLayout(forChild: &element, cachedSize: measure, ownSize: frame.size)
        var point = CGPoint()

        switch horizontalGravity {
        case .none: fallthrough
        case .some(.left): point.x = frame.minX + element.layoutMargins.left
        case .some(.center): point.x = frame.midX - (size.width * 0.5)
        case .some(.right): point.x = frame.maxX - size.width - element.layoutMargins.right
        }

        switch verticalGravity {
        case .none: fallthrough
        case .some(.top): point.y = frame.minY + element.layoutMargins.top
        case .some(.middle): point.y = frame.midY - (size.height * 0.5)
        case .some(.bottom): point.y = frame.maxY - size.height - element.layoutMargins.bottom
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
    /// Positions the element on the horizontal axis.
    /// - parameter horizontalGravity: Specifies where the element should be positioned horizontally.
    /// - returns: A `BayaGravityLayout`.
    func layoutGravitating(to horizontalGravity: BayaLayoutOptions.Gravity.Horizontal) -> BayaGravityLayout {
        return BayaGravityLayout(
            element: self,
            horizontalGravity: horizontalGravity,
            verticalGravity: nil)
    }

    /// Positions the element on the vertical axis.
    /// - parameter verticalGravity: Specifies where the element should be positioned vertically.
    /// - returns: A `BayaGravityLayout`.
    func layoutGravitating(to verticalGravity: BayaLayoutOptions.Gravity.Vertical) -> BayaGravityLayout {
        return BayaGravityLayout(
            element: self,
            horizontalGravity: nil,
            verticalGravity: verticalGravity)
    }

    /// Positions the element on both the horizontal and vertical axis.
    /// - parameter horizontalGravity: Specifies where the element should be positioned horizontally.
    /// - parameter verticalGravity: Specifies where the element should be positioned vertically.
    /// - returns: A `BayaGravityLayout`.
    func layoutGravitating(
        horizontally horizontalGravity: BayaLayoutOptions.Gravity.Horizontal,
        vertically verticalGravity: BayaLayoutOptions.Gravity.Vertical)
            -> BayaGravityLayout {
        return BayaGravityLayout(
            element: self,
            horizontalGravity: horizontalGravity,
            verticalGravity: verticalGravity)
    }
}

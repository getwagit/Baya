//
// Created by Markus Riegel on 02.09.16.
// Modified by Joachim Fröstl on 21.10.16. (Added gravity shortcuts in an extension to layoutable.)
// Copyright (c) 2016 wag it GmbH. All rights reserved.
//

import Foundation
import UIKit
import Oak

/**
    Simple layout that positions one child according to its gravity.
*/
struct GravityLayout: Layout {
    var layoutMargins: UIEdgeInsets
    var frame: CGRect

    private var element: Layoutable
    private let gravity: (LayoutOptions.Gravity.Horizontal, LayoutOptions.Gravity.Vertical)

    init(
        element: Layoutable,
        gravity: (LayoutOptions.Gravity.Horizontal, LayoutOptions.Gravity.Vertical),
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

extension Layoutable {
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

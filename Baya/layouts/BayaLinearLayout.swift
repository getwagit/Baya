//
// Copyright (c) 2016-2017 wag it GmbH.
// License: MIT
//

import Foundation
import UIKit

/**
    A simple layout that places children in a linear order.
    This Layout respects the margins of its children.
*/
public struct LinearLayout: BayaLayout, BayaLayoutIterator {
    public var layoutMargins: UIEdgeInsets
    public var frame: CGRect
    var orientation: BayaLayoutOptions.Orientation
    var direction: BayaLayoutOptions.Direction
    var spacing: CGFloat

    private var elements: [BayaLayoutable]

    init(
        elements: [BayaLayoutable],
        orientation: BayaLayoutOptions.Orientation,
        direction: BayaLayoutOptions.Direction = .normal,
        layoutMargins: UIEdgeInsets = UIEdgeInsets.zero,
        spacing: Int = 0) {
        self.elements = elements
        self.orientation = orientation
        self.direction = direction
        self.layoutMargins = layoutMargins
        self.spacing = CGFloat(spacing)
        self.frame = CGRect()
    }

    mutating public func layoutWith(frame: CGRect) {
        self.frame = frame
        switch (orientation, direction) {
        case (.horizontal, .normal):
            iterate(&elements) {
                e1, e2 in
                let size = CGSize(
                    width: e2.sizeThatFits(frame.size).width,
                    height: frame.height)
                let origin: CGPoint
                if let e1 = e1 {
                    origin = CGPoint(
                        x: e1.frame.maxX + e1.layoutMargins.right + spacing,
                        y: frame.minY)
                } else {
                    origin = frame.origin
                }
                return CGRect(origin: origin, size: size)
            }
        case (.horizontal, .reversed):
            iterate(&elements) {
                e1, e2 in
                let size = CGSize(
                    width: e2.sizeThatFits(frame.size).width,
                    height: frame.height)
                let origin: CGPoint
                if let e1 = e1 {
                    origin = CGPoint(
                        x: e1.frame.minX - e1.layoutMargins.left - spacing - size.width,
                        y: frame.minY)
                } else {
                    origin = CGPoint(
                        x: frame.maxX - size.width,
                        y: frame.minY)
                }
                return CGRect(origin: origin, size: size)
            }
        case (.vertical, .normal):
            iterate(&elements) {
                e1, e2 in
                let size = CGSize(
                    width: frame.width,
                    height: e2.sizeThatFits(frame.size).height)
                let origin: CGPoint
                if let e1 = e1 {
                    origin = CGPoint(
                        x: frame.minX,
                        y: e1.frame.maxY + e1.layoutMargins.bottom + spacing)
                } else {
                    origin = frame.origin
                }
                return CGRect(origin: origin, size: size)
            }
        case (.vertical, .reversed):
            iterate(&elements) {
                e1, e2 in
                let size = CGSize(
                    width: frame.width,
                    height: e2.sizeThatFits(frame.size).height)
                let origin: CGPoint
                if let e1 = e1 {
                    origin = CGPoint(
                        x: frame.minX,
                        y: e1.frame.minY - e1.layoutMargins.top - spacing - size.height)
                } else {
                    origin = CGPoint(
                        x: frame.minX,
                        y: frame.maxY - size.height)
                }
                return CGRect(origin: origin, size: size)
            }
        }
    }

    public func sizeThatFits(_ size: CGSize) -> CGSize {
        var resultSize: CGSize = CGSize()
        switch (orientation, direction) {
        case (.horizontal, .normal): fallthrough
        case (.horizontal, .reversed):
            let elementCount = elements.count
            resultSize.width = elementCount > 1 ? (CGFloat(elementCount - 1) * spacing) : 0
            for element in elements {
                let fit = element.sizeThatFitsWithMargins(size)
                resultSize.width += fit.width + element.layoutMargins.left + element.layoutMargins.right
                resultSize.height = max(
                    resultSize.height,
                    fit.height + element.layoutMargins.top + element.layoutMargins.bottom)
            }
        case (.vertical, .normal): fallthrough
        case (.vertical, .reversed):
            let elementCount = elements.count
            resultSize.height = elementCount > 1 ? (CGFloat(elementCount - 1) * spacing) : 0
            for element in elements {
                let fit = element.sizeThatFitsWithMargins(size)
                resultSize.width = max(
                    resultSize.width,
                    fit.width + element.layoutMargins.left + element.layoutMargins.right)
                resultSize.height += fit.height + element.layoutMargins.top + element.layoutMargins.bottom
            }
        }
        return resultSize
    }
}

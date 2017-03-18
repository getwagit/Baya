//
// Copyright (c) 2016-2017 wag it GmbH.
// License: MIT
//

import Foundation
import UIKit
import Oak

/**
    A simple layout that places children in a linear order.
    This Layout respects the margins of its children.
*/
public struct LinearLayout: BayaLayout, BayaLayoutIterator {

    var layoutMargins: UIEdgeInsets
    var orientation: LayoutOptions.Orientation
    var direction: LayoutOptions.Direction
    var frame: CGRect
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

    mutating func layoutWith(frame: CGRect) {
        self.frame = frame
        switch (orientation, direction) {
        case (.horizontal, .normal):
            iterate(&elements) {
                e1, e2 in
                let size = CGSize(
                    width: self.sizeThatFitsWithMargins(of: e2, size: frame.size).width,
                    height: frame.height - e2.layoutMargins.top - e2.layoutMargins.bottom)
                if let e1 = e1 {
                    let prevFrame = e1.frame
                    return CGRect(origin: CGPoint(
                        x: prevFrame.maxX + e1.layoutMargins.right + self.spacing + e2.layoutMargins.left,
                        y: frame.minY + e2.layoutMargins.top),
                        size: size)
                } else {
                    return CGRect(origin: CGPoint(
                        x: frame.minX + e2.layoutMargins.left,
                        y: frame.minY + e2.layoutMargins.top),
                        size: size)
                }
            }
        case (.horizontal, .reversed):
            iterate(&elements) {
                e1, e2 in
                let size = CGSize(
                    width: self.sizeThatFitsWithMargins(of: e2, size: frame.size).width,
                    height: frame.height - e2.layoutMargins.top - e2.layoutMargins.bottom)
                if let e1 = e1 {
                    let prevFrame = e1.frame
                    return CGRect(origin: CGPoint(
                        x: prevFrame.minX - e1.layoutMargins.left - self.spacing - e2.layoutMargins.right - size.width,
                        y: frame.minY + e2.layoutMargins.top),
                        size: size)
                } else {
                    return CGRect(origin: CGPoint(
                        x: frame.maxX - e2.layoutMargins.right - size.width,
                        y: frame.minY + e2.layoutMargins.top),
                        size: size)
                }
            }
        case (.vertical, .normal):
            iterate(&elements) {
                e1, e2 in
                let size = CGSize(
                    width: frame.width - e2.layoutMargins.left - e2.layoutMargins.right,
                    height: self.sizeThatFitsWithMargins(of: e2, size: frame.size).height)
                if let e1 = e1 {
                    let prevFrame = e1.frame
                    return CGRect(origin: CGPoint(
                        x: frame.minX + e2.layoutMargins.left,
                        y: prevFrame.maxY + e1.layoutMargins.bottom + self.spacing + e2.layoutMargins.top),
                        size: size)
                } else {
                    return CGRect(origin: CGPoint(
                        x: frame.minX + e2.layoutMargins.left,
                        y: frame.minY + e2.layoutMargins.top),
                        size: size)
                }
            }
        case (.vertical, .reversed):
            iterate(&elements) {
                e1, e2 in
                let size = CGSize(
                    width: frame.width - e2.layoutMargins.left - e2.layoutMargins.right,
                    height: self.sizeThatFitsWithMargins(of: e2, size: frame.size).height)
                if let e1 = e1 {
                    let prevFrame = e1.frame
                    return CGRect(origin: CGPoint(
                        x: frame.minX + e2.layoutMargins.left,
                        y: prevFrame.minY - e1.layoutMargins.top - self.spacing - e2.layoutMargins.bottom - size.height),
                        size: size)
                } else {
                    return CGRect(origin: CGPoint(
                        x: frame.minX + e2.layoutMargins.left,
                        y: frame.maxY - e2.layoutMargins.bottom - size.height),
                        size: size)
                }
            }
        }
    }

    func sizeThatFits(_ size: CGSize) -> CGSize {
        var resultSize: CGSize = CGSize()
        switch (orientation, direction) {
        case (.horizontal, .normal): fallthrough
        case (.horizontal, .reversed):
            let elementCount = elements.count
            resultSize.width = elementCount > 1 ? (CGFloat(elementCount - 1) * spacing) : 0
            for element in elements {
                let fit = sizeThatFitsWithMargins(of: element, size: size)
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
                let fit = sizeThatFitsWithMargins(of: element, size: size)
                resultSize.width = max(
                    resultSize.width,
                    fit.width + element.layoutMargins.left + element.layoutMargins.right)
                resultSize.height += fit.height + element.layoutMargins.top + element.layoutMargins.bottom
            }
        }
        return resultSize
    }
}

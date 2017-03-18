//
// Copyright (c) 2016-2017 wag it GmbH.
// License: MIT
//

import Foundation
import UIKit

/**
    A layout that distributes the available size evenly among the given elements.
*/
public struct BayaEqualSegmentsLayout: BayaLayout, BayaLayoutIterator {
    public var layoutMargins: UIEdgeInsets
    public var frame: CGRect
    var orientation: BayaLayoutOptions.Orientation
    var gutter: CGFloat

    private var elements: [BayaLayoutable]

    init(
        elements: [BayaLayoutable],
        orientation: BayaLayoutOptions.Orientation,
        gutter: CGFloat = 0,
        layoutMargins: UIEdgeInsets = UIEdgeInsets.zero) {
        self.elements = elements
        self.orientation = orientation
        self.gutter = gutter
        self.layoutMargins = layoutMargins
        self.frame = CGRect()
    }

    mutating public func layoutWith(frame: CGRect) {
        self.frame = frame
        guard elements.count > 0 else {
            return
        }
        switch orientation {
        case .horizontal:
            var elementSize = frame.size
            elementSize.width = (frame.width - gutter * CGFloat(elements.count - 1)) / CGFloat(elements.count)
            iterate(&elements) { e1, e2 in
                let origin: CGPoint
                if let e1 = e1 {
                    origin = CGPoint(
                        x: e1.frame.maxX + e1.layoutMargins.right + gutter,
                        y: frame.minY)
                } else {
                    origin = frame.origin
                }
                return CGRect(origin: origin, size: elementSize)
            }
        case .vertical:
            var elementSize = frame.size
            elementSize.height = (frame.height - gutter * CGFloat(elements.count - 1)) / CGFloat(elements.count)
            iterate(&elements) {
                e1, e2 in
                let origin: CGPoint
                if let e1 = e1 {
                    origin = CGPoint(
                        x: frame.minX,
                        y: e1.frame.maxY + e1.layoutMargins.bottom + gutter)
                } else {
                    origin = frame.origin
                }
                return CGRect(origin: origin, size: elementSize)
            }
        }
    }

    public func sizeThatFits(_ size: CGSize) -> CGSize {
        var size = CGSize()
        for element in elements {
            let fit = element.sizeThatFitsWithMargins(size)
            size.width = max(fit.width + element.horizontalMargins, size.width)
            size.height = max(fit.height + element.verticalMargins, size.height)
        }
        switch orientation {
        case .horizontal:
            size.width = size.width * CGFloat(elements.count) + gutter * CGFloat(elements.count - 1)
        case .vertical:
            size.height = size.height * CGFloat(elements.count) + gutter * CGFloat(elements.count - 1)
        }
        return size
    }
}

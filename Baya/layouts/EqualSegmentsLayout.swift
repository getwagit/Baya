//
// Copyright (c) 2016-2017 wag it GmbH.
// License: MIT
//

import Foundation
import UIKit
import Oak

/**
    A layout that distributes the available size evenly among the given elements.
*/
struct EqualSegmentsLayout: Layout, LayoutIterator {

    var layoutMargins: UIEdgeInsets
    var frame: CGRect
    var orientation: LayoutOptions.Orientation
    var gutter: CGFloat

    private var elements: [Layoutable]

    init(
            elements: [Layoutable],
            orientation: LayoutOptions.Orientation,
            gutter: CGFloat = 0,
            layoutMargins: UIEdgeInsets = UIEdgeInsets.zero) {
        self.elements = elements
        self.orientation = orientation
        self.gutter = gutter
        self.layoutMargins = layoutMargins
        self.frame = CGRect()
    }

    mutating func layoutWith(frame: CGRect) {
        self.frame = frame
        switch orientation {
        case .horizontal:
            var elementSize = frame.size
            elementSize.width = (frame.width - gutter * CGFloat(elements.count - 1)) / CGFloat(elements.count)
            iterate(&elements) {
                e1, e2 in
                if let e1 = e1 {
                    let prevFrame = e1.frame
                    return CGRect(
                        origin: CGPoint(
                            x: prevFrame.maxX + gutter,
                            y: frame.minY),
                        size: elementSize)
                } else {
                    return CGRect(origin: frame.origin, size: elementSize)
                }
            }
        case .vertical:
            var elementSize = frame.size
            elementSize.height = (frame.height - gutter * CGFloat(elements.count - 1)) / CGFloat(elements.count)
            iterate(&elements) {
                e1, e2 in
                if let e1 = e1 {
                    let prevFrame = e1.frame
                    return CGRect(origin: CGPoint(
                            x: frame.minX,
                            y: prevFrame.maxY + gutter),
                            size: elementSize)
                } else {
                    return CGRect(origin: frame.origin, size: elementSize)
                }
            }
        }
    }

    func sizeThatFits(_ size: CGSize) -> CGSize {
        var size = CGSize()
        for element in elements {
            let fit = sizeThatFitsWithMargins(of: element, size: size)
            size.width = max(fit.width + horizontalMargins(of: element), size.width)
            size.height = max(fit.height + verticalMargins(of: element), size.height)
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

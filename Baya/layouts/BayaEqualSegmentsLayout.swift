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
    private var measures = [CGSize]()

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
            let segmentWidth = (frame.width - gutter * CGFloat(elements.count - 1)) / CGFloat(elements.count)
            iterate(&elements, measures) { e1, e2, e2s in
                let origin: CGPoint
                let size = saveMeasure(e2s: e2s, e2: &e2, size: frame.size)
                if let e1 = e1 {
                    origin = CGPoint(
                        x: e1.frame.minX - e1.layoutMargins.left + segmentWidth + gutter,
                        y: frame.minY)
                } else {
                    origin = frame.origin
                }
                return CGRect(origin: origin, size: size)
            }
        case .vertical:
            let segmentHeight = (frame.height - gutter * CGFloat(elements.count - 1)) / CGFloat(elements.count)
            iterate(&elements, measures) { e1, e2, e2s in
                let origin: CGPoint
                let size = saveMeasure(e2s: e2s, e2: &e2, size: frame.size)
                if let e1 = e1 {
                    origin = CGPoint(
                        x: frame.minX,
                        y: e1.frame.minY - e1.layoutMargins.top + segmentHeight + gutter)
                } else {
                    origin = frame.origin
                }
                return CGRect(origin: origin, size: size)
            }
        }
    }

    public mutating func sizeThatFits(_ size: CGSize) -> CGSize {
        measures = measure(&elements, size: size)
        var size = CGSize()
        for i in 0..<elements.count {
            let fit = measures[i]
            let element = elements[i]
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

extension Sequence where Iterator.Element: BayaLayoutable {
    /**
        Distributes the available size evenly.
    */
    func layoutEqualSegments(
        orientation: BayaLayoutOptions.Orientation,
        gutter: CGFloat = 0,
        layoutMargins: UIEdgeInsets = UIEdgeInsets.zero)
            -> BayaEqualSegmentsLayout {
        return BayaEqualSegmentsLayout(
            elements: self.array(),
            orientation: orientation,
            gutter: gutter,
            layoutMargins: layoutMargins)
    }
}

extension Sequence where Iterator.Element == BayaLayoutable {
    /**
        Distributes the available size evenly.
    */
    func layoutEqualSegments(
        orientation: BayaLayoutOptions.Orientation,
        gutter: CGFloat = 0,
        layoutMargins: UIEdgeInsets = UIEdgeInsets.zero)
            -> BayaEqualSegmentsLayout {
        return BayaEqualSegmentsLayout(
            elements: self,
            elements: self.array(),
            orientation: orientation,
            gutter: gutter,
            layoutMargins: layoutMargins)
    }
}

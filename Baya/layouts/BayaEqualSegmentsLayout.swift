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
    private var measuredMaxDimension: CGSize?

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
        if measuredMaxDimension == nil {
            measuredMaxDimension = measureChildrenAndFindMaxDimensions(frame.size)
        }
        switch orientation {
        case .horizontal:
            let maxSegmentWidth = (frame.width - gutter * CGFloat(elements.count - 1)) / CGFloat(elements.count)
            let segmentWidth = min(maxSegmentWidth > 0 ? maxSegmentWidth : 0, measuredMaxDimension!.width)
            iterate(&elements, measures) { e1, e2, e2s in
                let origin: CGPoint
                let size = saveMeasure(e2s: e2s, e2: &e2, size: frame.size)
                if let e1 = e1 {
                    origin = CGPoint(
                        x: e1.frame.minX
                            - e1.layoutMargins.left
                            + segmentWidth
                            + gutter
                            + e2.layoutMargins.left,
                        y: frame.minY + e2.layoutMargins.top)
                } else {
                    origin = CGPoint(
                        x: frame.minX + e2.layoutMargins.left,
                        y: frame.minY + e2.layoutMargins.top)
                }
                return CGRect(origin: origin, size: size)
            }
        case .vertical:
            let maxSegmentHeight = (frame.height - gutter * CGFloat(elements.count - 1)) / CGFloat(elements.count)
            let segmentHeight = min(maxSegmentHeight > 0 ? maxSegmentHeight : 0, measuredMaxDimension!.height)
            iterate(&elements, measures) { e1, e2, e2s in
                let origin: CGPoint
                let size = saveMeasure(e2s: e2s, e2: &e2, size: frame.size)
                if let e1 = e1 {
                    origin = CGPoint(
                        x: frame.minX + e2.layoutMargins.left,
                        y: e1.frame.minY
                            - e1.layoutMargins.top
                            + segmentHeight
                            + gutter
                            + e2.layoutMargins.top)
                } else {
                    origin = CGPoint(
                        x: frame.minX + e2.layoutMargins.left,
                        y: frame.minY + e2.layoutMargins.top)
                }
                return CGRect(origin: origin, size: size)
            }
        }
    }

    mutating public func sizeThatFits(_ size: CGSize) -> CGSize {
        guard elements.count > 0 else {
            return CGSize()
        }
        measuredMaxDimension = measureChildrenAndFindMaxDimensions(size)
        switch orientation {
        case .horizontal:
            return CGSize(
                width: measuredMaxDimension!.width * CGFloat(elements.count) + gutter * CGFloat(elements.count - 1),
                height: measuredMaxDimension!.height)
        case .vertical:
            return CGSize(
                width: measuredMaxDimension!.width,
                height: measuredMaxDimension!.height * CGFloat(elements.count) + gutter * CGFloat(elements.count - 1))
        }
    }

    mutating private func measureChildrenAndFindMaxDimensions(_ size: CGSize) -> CGSize {
        measures = measure(&elements, size: size)
        var size = CGSize()
        for i in 0..<elements.count {
            let fit = measures[i]
            let element = elements[i]
            size.width = max(fit.width + element.horizontalMargins, size.width)
            size.height = max(fit.height + element.verticalMargins, size.height)
        }
        return size
    }
}

extension Sequence where Iterator.Element: BayaLayoutable {
    /**
        Distributes the available size evenly.
    */
    func layoutAsEqualSegments(
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
    func layoutAsEqualSegments(
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

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
    var spacing: CGFloat

    private var elements: [BayaLayoutable]
    private var measures = [CGSize]()
    private var measuredMaxDimension: CGSize?

    init(
        elements: [BayaLayoutable],
        orientation: BayaLayoutOptions.Orientation,
        spacing: CGFloat = 0,
        layoutMargins: UIEdgeInsets = UIEdgeInsets.zero) {
        self.elements = elements
        self.orientation = orientation
        self.spacing = spacing
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
            let maxSegmentWidth = (frame.width - spacing * CGFloat(elements.count - 1)) / CGFloat(elements.count)
            let segmentWidth = maxSegmentWidth > 0 ? maxSegmentWidth : 0
            let segmentSize = CGSize(width: segmentWidth, height: frame.height)
            let measures = measureIfNecessary(&elements, cache: self.measures, size: segmentSize)
            iterate(&elements, measures) { e1, e2, e2s in
                let origin: CGPoint
                let size: CGSize = BayaEqualSegmentsLayout.combineSizeForLayout(
                    for: e2,
                    wrappingSize: e2s,
                    matchingSize: segmentSize.subtractMargins(ofElement: e2))
                if let e1 = e1 {
                    origin = CGPoint(
                        x: e1.frame.minX
                            - e1.layoutMargins.left
                            + segmentWidth
                            + spacing
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
            let maxSegmentHeight = (frame.height - spacing * CGFloat(elements.count - 1)) / CGFloat(elements.count)
            let segmentHeight = maxSegmentHeight > 0 ? maxSegmentHeight : 0
            let segmentSize = CGSize(width: frame.width, height: segmentHeight)
            let measures = measureIfNecessary(&elements, cache: self.measures, size: segmentSize)
            iterate(&elements, measures) { e1, e2, e2s in
                let origin: CGPoint
                let size: CGSize = BayaEqualSegmentsLayout.combineSizeForLayout(
                    for: e2,
                    wrappingSize: e2s,
                    matchingSize: segmentSize.subtractMargins(ofElement: e2))
                if let e1 = e1 {
                    origin = CGPoint(
                        x: frame.minX + e2.layoutMargins.left,
                        y: e1.frame.minY
                            - e1.layoutMargins.top
                            + segmentHeight
                            + spacing
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
                width: measuredMaxDimension!.width * CGFloat(elements.count) + spacing * CGFloat(elements.count - 1),
                height: measuredMaxDimension!.height)
        case .vertical:
            return CGSize(
                width: measuredMaxDimension!.width,
                height: measuredMaxDimension!.height * CGFloat(elements.count) + spacing * CGFloat(elements.count - 1))
        }
    }

    mutating private func measureChildrenAndFindMaxDimensions(_ size: CGSize) -> CGSize {
        let elementCount = CGFloat(elements.count)
        let segmentSize = orientation == .horizontal ?
            CGSize(width: (size.width - (elementCount - 1) * spacing) / elementCount, height: size.height) :
            CGSize(width: size.width, height: (size.height - (elementCount - 1) * spacing) / elementCount)
        measures = measure(&elements, size: segmentSize)
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

public extension Sequence where Iterator.Element: BayaLayoutable {
    /// Distributes the available width or height evenly among the elements. Lays out the elements in horizontal or
    /// vertical direction.
    /// - parameter orientation: Determines if the elements should be laid out in horizontal or vertical direction. Also
    ///   determines which side of the available size should be segmented and distributed among the elements.
    /// - parameter spacing: The gap between the elements.
    /// - parameter layoutMargins: The layout's margins.
    /// - returns: A `BayaEqualSegmentsLayout`.
    func layoutAsEqualSegments(
        orientation: BayaLayoutOptions.Orientation,
        spacing: CGFloat = 0,
        layoutMargins: UIEdgeInsets = UIEdgeInsets.zero)
            -> BayaEqualSegmentsLayout {
        return BayaEqualSegmentsLayout(
            elements: self.array(),
            orientation: orientation,
            spacing: spacing,
            layoutMargins: layoutMargins)
    }
}

public extension Sequence where Iterator.Element == BayaLayoutable {
    /// Distributes the available width or height evenly among the elements. Lays out the elements in horizontal or
    /// vertical direction.
    /// - parameter orientation: Determines if the elements should be laid out in horizontal or vertical direction. Also
    ///   determines which side of the available size should be segmented and distributed among the elements.
    /// - parameter spacing: The gap between the elements.
    /// - parameter layoutMargins: The layout's margins.
    /// - returns: A `BayaEqualSegmentsLayout`.
    func layoutAsEqualSegments(
        orientation: BayaLayoutOptions.Orientation,
        spacing: CGFloat = 0,
        layoutMargins: UIEdgeInsets = UIEdgeInsets.zero)
            -> BayaEqualSegmentsLayout {
        return BayaEqualSegmentsLayout(
            elements: self.array(),
            orientation: orientation,
            spacing: spacing,
            layoutMargins: layoutMargins)
    }
}

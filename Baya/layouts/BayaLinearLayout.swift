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
public struct BayaLinearLayout: BayaLayout, BayaLayoutIterator {
    public var bayaMargins: UIEdgeInsets
    public var frame: CGRect
    var orientation: BayaLayoutOptions.Orientation
    var spacing: CGFloat

    private var elements: [BayaLayoutable]
    private var measures = [CGSize]()

    init(
        elements: [BayaLayoutable],
        orientation: BayaLayoutOptions.Orientation,
        spacing: CGFloat = 0,
        bayaMargins: UIEdgeInsets) {
        self.elements = elements
        self.orientation = orientation
        self.bayaMargins = bayaMargins
        self.spacing = spacing
        self.frame = CGRect()
    }

    mutating public func layoutWith(frame: CGRect) {
        self.frame = frame
        guard elements.count > 0 else {
            return
        }
        let measures = measureIfNecessary(&elements, cache: self.measures, size: frame.size)
        switch orientation {
        case .horizontal:
            iterate(&elements, measures) { e1, e2, e2s in
                let size = BayaLinearLayout.calculateSizeForLayout(
                    withOrientation: .horizontal,
                    forChild: e2,
                    cachedSize: e2s,
                    ownSize: frame.size)
                let origin: CGPoint
                if let e1 = e1 {
                    origin = CGPoint(
                        x: e1.frame.maxX
                            + e1.bayaMargins.right
                            + spacing
                            + e2.bayaMargins.left,
                        y: frame.minY + e2.bayaMargins.top)
                } else {
                    origin = CGPoint(
                        x: frame.minX + e2.bayaMargins.left,
                        y: frame.minY + e2.bayaMargins.top)
                }
                return CGRect(origin: origin, size: size)
            }
        case .vertical:
            iterate(&elements, measures) { e1, e2, e2s in
                let size = BayaLinearLayout.calculateSizeForLayout(
                    withOrientation: .vertical,
                    forChild: e2,
                    cachedSize: e2s,
                    ownSize: frame.size)
                let origin: CGPoint
                if let e1 = e1 {
                    origin = CGPoint(
                        x: frame.minX + e2.bayaMargins.left,
                        y: e1.frame.maxY
                            + e1.bayaMargins.bottom
                            + spacing
                            + e2.bayaMargins.top)
                } else {
                    origin = CGPoint(
                        x: frame.minX + e2.bayaMargins.left,
                        y: frame.minY + e2.bayaMargins.top)
                }
                return CGRect(origin: origin, size: size)
            }
        }
    }

    mutating public func sizeThatFits(_ size: CGSize) -> CGSize {
        measures = measure(&elements, size: size)
        var resultSize: CGSize = CGSize()
        switch orientation {
        case .horizontal:
            let elementCount = elements.count
            resultSize.width = elementCount > 1 ? (CGFloat(elementCount - 1) * spacing) : 0
            for i in 0..<elements.count {
                let fit = measures[i]
                let element = elements[i]
                resultSize.width += fit.width + element.bayaMargins.left + element.bayaMargins.right
                resultSize.height = max(
                    resultSize.height,
                    fit.height + element.bayaMargins.top + element.bayaMargins.bottom)
            }
        case .vertical:
            let elementCount = elements.count
            resultSize.height = elementCount > 1 ? (CGFloat(elementCount - 1) * spacing) : 0
            for i in 0..<elements.count {
                let fit = measures[i]
                let element = elements[i]
                resultSize.width = max(
                    resultSize.width,
                    fit.width + element.bayaMargins.left + element.bayaMargins.right)
                resultSize.height += fit.height + element.bayaMargins.top + element.bayaMargins.bottom
            }
        }
        return resultSize
    }

    private static func calculateSizeForLayout(
        withOrientation orientation: BayaLayoutOptions.Orientation,
        forChild element: BayaLayoutable,
        cachedSize: CGSize,
        ownSize availableSize: CGSize)
            -> CGSize {
        switch orientation {
        case .horizontal:
            guard element.bayaModes.height == .matchParent else {
                return cachedSize
            }
            return CGSize(
                width: cachedSize.width,
                height: availableSize.height - element.verticalMargins)
        case .vertical:
            guard element.bayaModes.width == .matchParent else {
                return cachedSize
            }
            return CGSize(
                width: availableSize.width - element.horizontalMargins,
                height: cachedSize.height)
        }
    }
}

public extension Sequence where Iterator.Element: BayaLayoutable {
    /// Aligns all elements in a single direction.
    /// - parameter orientation: Determines if the elements should be laid out in horizontal or vertical direction.
    /// - parameter spacing: The gap between the elements.
    /// - parameter bayaMargins: The layout's margins.
    /// - returns: A `BayaLinearLayout`.
    func layoutLinearly(
        orientation: BayaLayoutOptions.Orientation,
        spacing: CGFloat = 0,
        bayaMargins: UIEdgeInsets = UIEdgeInsets.zero)
            -> BayaLinearLayout {
        return BayaLinearLayout(
            elements: self.array(),
            orientation: orientation,
            spacing: spacing,
            bayaMargins: bayaMargins)
    }
}

public extension Sequence where Iterator.Element == BayaLayoutable {
    /// Aligns all elements in a single direction.
    /// - parameter orientation: Determines if the elements should be laid out in horizontal or vertical direction.
    /// - parameter spacing: The gap between the elements.
    /// - parameter bayaMargins: The layout's margins.
    /// - returns: A `BayaLinearLayout`.
    func layoutLinearly(
        orientation: BayaLayoutOptions.Orientation,
        spacing: CGFloat = 0,
        bayaMargins: UIEdgeInsets = UIEdgeInsets.zero)
            -> BayaLinearLayout {
        return BayaLinearLayout(
            elements: self.array(),
            orientation: orientation,
            spacing: spacing,
            bayaMargins: bayaMargins)
    }
}

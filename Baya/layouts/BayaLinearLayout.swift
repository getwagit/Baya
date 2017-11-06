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
    public var layoutMargins: UIEdgeInsets
    public var frame: CGRect
    var orientation: BayaLayoutOptions.Orientation
    var spacing: CGFloat

    private var elements: [BayaLayoutable]
    private var measures = [CGSize]()

    init(
        elements: [BayaLayoutable],
        orientation: BayaLayoutOptions.Orientation,
        spacing: CGFloat = 0,
        layoutMargins: UIEdgeInsets = UIEdgeInsets.zero) {
        self.elements = elements
        self.orientation = orientation
        self.layoutMargins = layoutMargins
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
                            + e1.layoutMargins.right
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
            iterate(&elements, measures) { e1, e2, e2s in
                let size = BayaLinearLayout.calculateSizeForLayout(
                    withOrientation: .vertical,
                    forChild: e2,
                    cachedSize: e2s,
                    ownSize: frame.size)
                let origin: CGPoint
                if let e1 = e1 {
                    origin = CGPoint(
                        x: frame.minX + e2.layoutMargins.left,
                        y: e1.frame.maxY
                            + e1.layoutMargins.bottom
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
        measures = measure(&elements, size: size)
        var resultSize: CGSize = CGSize()
        switch orientation {
        case .horizontal:
            let elementCount = elements.count
            resultSize.width = elementCount > 1 ? (CGFloat(elementCount - 1) * spacing) : 0
            for i in 0..<elements.count {
                let fit = measures[i]
                let element = elements[i]
                resultSize.width += fit.width + element.layoutMargins.left + element.layoutMargins.right
                resultSize.height = max(
                    resultSize.height,
                    fit.height + element.layoutMargins.top + element.layoutMargins.bottom)
            }
        case .vertical:
            let elementCount = elements.count
            resultSize.height = elementCount > 1 ? (CGFloat(elementCount - 1) * spacing) : 0
            for i in 0..<elements.count {
                let fit = measures[i]
                let element = elements[i]
                resultSize.width = max(
                    resultSize.width,
                    fit.width + element.layoutMargins.left + element.layoutMargins.right)
                resultSize.height += fit.height + element.layoutMargins.top + element.layoutMargins.bottom
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
            guard element.layoutModes.height == .matchParent else {
                return cachedSize
            }
            return CGSize(
                width: cachedSize.width,
                height: availableSize.height - element.verticalMargins)
        case .vertical:
            guard element.layoutModes.width == .matchParent else {
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
    /// - parameter layoutMargins: The layout's margins.
    /// - returns: A `BayaLinearLayout`.
    func layoutLinearly(
        orientation: BayaLayoutOptions.Orientation,
        spacing: CGFloat = 0,
        layoutMargins: UIEdgeInsets = UIEdgeInsets.zero)
            -> BayaLinearLayout {
        return BayaLinearLayout(
            elements: self.array(),
            orientation: orientation,
            spacing: spacing,
            layoutMargins: layoutMargins)
    }
}

public extension Sequence where Iterator.Element == BayaLayoutable {
    /// Aligns all elements in a single direction.
    /// - parameter orientation: Determines if the elements should be laid out in horizontal or vertical direction.
    /// - parameter spacing: The gap between the elements.
    /// - parameter layoutMargins: The layout's margins.
    /// - returns: A `BayaLinearLayout`.
    func layoutLinearly(
        orientation: BayaLayoutOptions.Orientation,
        spacing: CGFloat = 0,
        layoutMargins: UIEdgeInsets = UIEdgeInsets.zero)
            -> BayaLinearLayout {
        return BayaLinearLayout(
            elements: self.array(),
            orientation: orientation,
            spacing: spacing,
            layoutMargins: layoutMargins)
    }
}

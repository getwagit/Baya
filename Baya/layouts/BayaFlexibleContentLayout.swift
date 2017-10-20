//
// Copyright (c) 2016-2017 wag it GmbH.
// License: MIT
//

import Foundation
import UIKit

/**
    A layout that subtracts the frames of two optional elements before laying out its content element.
    First the elements before and after the content will be measured and positioned, then the content
    element will be measured and positioned with the remaining space.
 */
public struct BayaFlexibleContentLayout: BayaLayout {
    public var layoutMargins: UIEdgeInsets
    public var frame: CGRect
    var orientation: BayaLayoutOptions.Orientation
    var spacing: CGFloat

    private var elements: (before: BayaLayoutable?, content: BayaLayoutable, after: BayaLayoutable?)
    private var measures: (before: CGSize?, content: CGSize?, after: CGSize?) = (before: nil, content: nil, after: nil)

    init(
        elements: (before: BayaLayoutable?, content: BayaLayoutable, after: BayaLayoutable?),
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
        if measures.before == nil {
            measures.before = elements.before?.sizeThatFitsWithMargins(frame.size)
        }
        if measures.after == nil {
            measures.after = elements.after?.sizeThatFitsWithMargins(frame.size)
        }
        let relevantBeforeWidth: CGFloat
        let relevantAfterWidth: CGFloat
        let relevantBeforeHeight: CGFloat
        let relevantAfterHeight: CGFloat

        switch orientation {
        case .horizontal:
            relevantBeforeWidth = measures.before?.width
                .add(elements.before!.horizontalMargins).add(spacing) ?? 0
            relevantAfterWidth = measures.after?.width
                .add(elements.after!.horizontalMargins).add(spacing) ?? 0
            relevantBeforeHeight = 0
            relevantAfterHeight = 0
            if measures.content == nil {
                measures.content = elements.content.sizeThatFitsWithMargins(CGSize(
                    width: frame.width - relevantBeforeWidth - relevantAfterWidth,
                    height: frame.height))
            }
        case .vertical:
            relevantBeforeWidth = 0
            relevantAfterWidth = 0
            relevantBeforeHeight = measures.before?.height
                .add(elements.before!.verticalMargins).add(spacing) ?? 0
            relevantAfterHeight = measures.after?.height
                .add(elements.after!.verticalMargins).add(spacing) ?? 0
            if measures.content == nil {
                measures.content = elements.content.sizeThatFitsWithMargins(CGSize(
                    width: frame.width,
                    height: frame.height - relevantBeforeHeight - relevantAfterHeight))
            }
        }

        switch orientation {
        case .horizontal:
            if let elementBefore = elements.before {
                elements.before?.layoutWith(frame: CGRect(
                    x: frame.minX + elementBefore.layoutMargins.left,
                    y: frame.minY + elementBefore.layoutMargins.top,
                    width: measures.before!.width,
                    height: elementBefore.layoutModes.height == .wrapContent ?
                        measures.before!.height : frame.height - elementBefore.verticalMargins))
            }

            if let elementAfter = elements.after {
                elements.after?.layoutWith(frame: CGRect(
                    x: frame.maxX - measures.after!.width - elementAfter.layoutMargins.right,
                    y: frame.minY + elementAfter.layoutMargins.top,
                    width: measures.after!.width,
                    height: elementAfter.layoutModes.width == .wrapContent ?
                        measures.after!.height : frame.height - elementAfter.verticalMargins))
            }

            let elementContent = elements.content
            elements.content.layoutWith(frame: CGRect(
                x: frame.minX
                    + relevantBeforeWidth
                    + elementContent.layoutMargins.left,
                y: frame.minY + elementContent.layoutMargins.top,
                width: elementContent.layoutModes.width == .wrapContent ?
                    measures.content!.width : frame.width - relevantBeforeWidth - relevantAfterWidth,
                height: elementContent.layoutModes.height == .wrapContent ?
                    measures.content!.height : frame.height - elementContent.verticalMargins))
        case .vertical:
            if let elementBefore = elements.before {
                elements.before?.layoutWith(frame: CGRect(
                    x: frame.minX + elementBefore.layoutMargins.left,
                    y: frame.minY + elementBefore.layoutMargins.top,
                    width:  elementBefore.layoutModes.width == .wrapContent ?
                        measures.before!.width : frame.width - elementBefore.horizontalMargins,
                    height: measures.before!.height))
            }

            if let elementAfter = elements.after {
                elements.after?.layoutWith(frame: CGRect(
                    x: frame.minX + elementAfter.layoutMargins.left,
                    y: frame.maxY - measures.after!.height - elementAfter.layoutMargins.bottom,
                    width: elementAfter.layoutModes.width == .wrapContent ?
                        measures.after!.width : frame.width - elementAfter.horizontalMargins,
                    height: measures.after!.height))
            }

            let elementContent = elements.content
            elements.content.layoutWith(frame: CGRect(
                x: frame.minX + elementContent.layoutMargins.left,
                y: frame.minY
                    + relevantBeforeHeight
                    + elementContent.layoutMargins.top,
                width: elementContent.layoutModes.width == .wrapContent ?
                    measures.content!.width : frame.width - elementContent.horizontalMargins,
                height: elementContent.layoutModes.height == .wrapContent ?
                    measures.content!.height : frame.height - relevantBeforeHeight - relevantAfterHeight))
        }
    }

    public mutating func sizeThatFits(_ size: CGSize) -> CGSize {
        measures.before = elements.before?.sizeThatFitsWithMargins(size)
        measures.after = elements.after?.sizeThatFitsWithMargins(size)
        let beforeWithMargins = measures.before?.addMargins(ofElement: elements.before!)
        let afterWithMargins = measures.after?.addMargins(ofElement: elements.after!)

        switch orientation {
        case .horizontal:
            let relevantBeforeWidth = beforeWithMargins?.width.add(spacing) ?? 0
            let relevantAfterWidth = afterWithMargins?.width.add(spacing) ?? 0
            let availableWidth = max(size.width - relevantBeforeWidth - relevantAfterWidth, 0)
            measures.content = elements.content.sizeThatFitsWithMargins(CGSize(width: availableWidth, height: size.height))
            let contentWithMargins = measures.content!.addMargins(ofElement: elements.content)
            return CGSize(
                width: relevantBeforeWidth + relevantAfterWidth + contentWithMargins.width,
                height: max(beforeWithMargins?.height ?? 0, afterWithMargins?.height ?? 0, contentWithMargins.height))

        case .vertical:
            let relevantBeforeHeight = beforeWithMargins?.height.add(spacing) ?? 0
            let relevantAfterHeight = afterWithMargins?.height.add(spacing) ?? 0
            let availableHeight = max(size.width - relevantBeforeHeight - relevantAfterHeight, 0)
            measures.content = elements.content.sizeThatFitsWithMargins(CGSize(width: size.width, height: availableHeight))
            let contentWithMargins = measures.content!.addMargins(ofElement: elements.content)
            return CGSize(
                width: max(beforeWithMargins?.width ?? 0, afterWithMargins?.width ?? 0, contentWithMargins.width),
                height: relevantBeforeHeight + relevantAfterHeight + contentWithMargins.height)
        }
    }
}

public extension BayaLayoutable {
    /// The element is laid out in the space that remains after subtracting the sizes of two optional elements from the avaiable size. 
    /// The optional elements will be laid out before and after the element.
    /// - parameter elementBefore: This optional element will be placed before the element. Its measured size will be subtracted from
    ///   the available size.
    /// - parameter elementAfter: This optional element will be placed after the element. Its measured size will be subtracted from
    ///   the available size.
    /// - parameter orientation: Determines if the elements should be laid out in horizontal or vertical direction.
    /// - parameter spacing: The gap between the elements.
    /// - parameter layoutMargins: The layout's margins.
    /// - returns: A `BayaFlexibleContentLayout`.
    func layoutFlexible(
        elementBefore: BayaLayoutable? = nil,
        elementAfter: BayaLayoutable? = nil,
        orientation: BayaLayoutOptions.Orientation = .horizontal,
        spacing: CGFloat = 0,
        layoutMargins: UIEdgeInsets = UIEdgeInsets.zero)
            -> BayaFlexibleContentLayout {
        return BayaFlexibleContentLayout(
            elements: (before:  elementBefore, content: self, after: elementAfter),
            orientation: orientation,
            spacing: spacing,
            layoutMargins: layoutMargins)
    }
}

private extension CGFloat {
    func add(_ other: CGFloat) -> CGFloat {
        return self + other
    }
}

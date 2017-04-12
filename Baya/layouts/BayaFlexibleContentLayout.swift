//
// Copyright (c) 2016-2017 wag it GmbH.
// License: MIT
//

import Foundation
import UIKit

/**
    A Layout that stretches a Layoutable to fill the available space.
 */
public struct FlexibleContentLayout: BayaLayout {
    public var layoutMargins: UIEdgeInsets
    public var frame: CGRect
    var orientation: BayaLayoutOptions.Orientation
    var spacing: CGFloat

    private var elements: (before: BayaLayoutable?, content: BayaLayoutable, after: BayaLayoutable?)
    private var measures: (before: CGSize?, content: CGSize?, after: CGSize?) = (before: nil, content: nil, after: nil)

    init(
        elements: (before: BayaLayoutable?, content: BayaLayoutable, after: BayaLayoutable?),
        orientation: BayaLayoutOptions.Orientation,
        spacing: Int = 0,
        layoutMargins: UIEdgeInsets = UIEdgeInsets.zero) {
        self.elements = elements
        self.orientation = orientation
        self.layoutMargins = layoutMargins
        self.spacing = CGFloat(spacing)
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
            if elements.before != nil {
                elements.before!.layoutWith(frame: CGRect(
                    x: frame.minX + elements.before!.layoutMargins.left,
                    y: frame.minY + elements.before!.layoutMargins.top,
                    width: measures.before!.width,
                    height: measures.before!.height))
            }

            if elements.after != nil {
                elements.after!.layoutWith(frame: CGRect(
                    x: frame.maxX - measures.after!.width - elements.after!.layoutMargins.right,
                    y: frame.minY + elements.after!.layoutMargins.top,
                    width: measures.after!.width,
                    height: measures.after!.height))
            }

            elements.content.layoutWith(frame: CGRect(
                x: frame.minX
                    + relevantBeforeWidth
                    + elements.content.layoutMargins.left,
                y: frame.minY + elements.content.layoutMargins.top,
                width: measures.content!.width,
                height: measures.content!.height))
        case .vertical:
            if elements.before != nil {
                elements.before!.layoutWith(frame: CGRect(
                    x: frame.minX + elements.before!.layoutMargins.left,
                    y: frame.minY + elements.before!.layoutMargins.top,
                    width:  measures.before!.width,
                    height: measures.before!.height))
            }

            if elements.after != nil {
                elements.after!.layoutWith(frame: CGRect(
                    x: frame.minX + elements.after!.layoutMargins.left,
                    y: frame.maxY - measures.after!.height - elements.after!.layoutMargins.bottom,
                    width: measures.before!.width,
                    height: measures.after!.height))
            }

            elements.content.layoutWith(frame: CGRect(
                x: frame.minX + elements.content.layoutMargins.left,
                y: frame.minY
                    + relevantBeforeHeight
                    + elements.content.layoutMargins.top,
                width: measures.content!.width,
                height: measures.content!.height))
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
    func layoutFlexibleContent(
        orientation: BayaLayoutOptions.Orientation,
        before: BayaLayoutable? = nil,
        after: BayaLayoutable? = nil,
        spacing: Int = 0,
        layoutMargins: UIEdgeInsets = UIEdgeInsets.zero)
            -> FlexibleContentLayout {
        return FlexibleContentLayout(
            elements: (before:  before, content: self, after: after),
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
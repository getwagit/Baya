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
        if measures.content == nil {
            measures.content = elements.content.sizeThatFitsWithMargins(frame.size)
        }

        switch orientation {
        case .horizontal:
            if elements.before != nil {
                elements.before!.layoutWith(frame: CGRect(
                    x: frame.minX + elements.before!.layoutMargins.left,
                    y: frame.minY + elements.before!.layoutMargins.top,
                    width: measures.before!.width,
                    height: frame.height - elements.before!.verticalMargins))
            }

            if elements.after != nil {
                elements.after!.layoutWith(frame: CGRect(
                    x: frame.minX + frame.width - measures.after!.width - elements.after!.layoutMargins.right,
                    y: frame.minY + elements.after!.layoutMargins.top,
                    width: measures.after!.width,
                    height: frame.height - elements.after!.verticalMargins))
            }

            let relevantBeforeWidth = elements.before?.widthWithMargins.add(spacing) ?? 0
            let relevantAfterWidth = elements.after?.widthWithMargins.add(spacing) ?? 0
            elements.content.layoutWith(frame: CGRect(
                x: frame.minX
                    + relevantBeforeWidth
                    + elements.content.layoutMargins.left,
                y: frame.minY + elements.content.layoutMargins.top,
                width: frame.width
                    - elements.content.horizontalMargins
                    - relevantBeforeWidth
                    - relevantAfterWidth,
                height: frame.height
                    - elements.content.verticalMargins))
        case .vertical:
            if elements.before != nil {
                elements.before!.layoutWith(frame: CGRect(
                    x: frame.minX + elements.before!.layoutMargins.left,
                    y: frame.minY + elements.before!.layoutMargins.top,
                    width: frame.width - elements.before!.horizontalMargins,
                    height: measures.before!.height))
            }

            if elements.after != nil {
                elements.after!.layoutWith(frame: CGRect(
                    x: frame.minX + elements.after!.layoutMargins.left,
                    y: frame.minY + frame.height - measures.after!.height - elements.after!.layoutMargins.bottom,
                    width: frame.width - elements.after!.horizontalMargins,
                    height: measures.after!.height))
            }

            let relevantBeforeHeight = elements.before?.heightWithMargins.add(spacing) ?? 0
            let relevantAfterHeight = elements.after?.heightWithMargins.add(spacing) ?? 0
            elements.content.layoutWith(frame: CGRect(
                x: frame.minX + elements.content.layoutMargins.left,
                y: frame.minY
                    + relevantBeforeHeight
                    + elements.content.layoutMargins.top,
                width: frame.width
                    - elements.content.horizontalMargins,
                height: frame.height
                    - elements.content.verticalMargins
                    - relevantBeforeHeight
                    - relevantAfterHeight))
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
            return CGSize(
                width: relevantBeforeWidth + relevantAfterWidth + measures.content!.width,
                height: max(beforeWithMargins?.height ?? 0, afterWithMargins?.height ?? 0, measures.content!.height))

        case .vertical:
            let relevantBeforeHeight = beforeWithMargins?.height.add(spacing) ?? 0
            let relevantAfterHeight = afterWithMargins?.height.add(spacing) ?? 0
            let availableHeight = max(size.width - relevantBeforeHeight - relevantAfterHeight, 0)
            measures.content = elements.content.sizeThatFitsWithMargins(CGSize(width: size.width, height: availableHeight))
            return CGSize(
                width: max(beforeWithMargins?.width ?? 0, afterWithMargins?.width ?? 0, measures.content!.width),
                height: relevantBeforeHeight + relevantAfterHeight + measures.content!.height)
        }
    }
}

public extension BayaLayoutable {
    func layoutFlexibleContent(
        orientation: BayaLayoutOptions.Orientation,
        before: BayaLayoutable?,
        after: BayaLayoutable?,
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
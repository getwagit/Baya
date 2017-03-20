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
        switch orientation {
        case .horizontal:
            if elements.before != nil {
                let elementBeforeContentSize = self.sizeThatFitsWithMargins(of: elements.before!, size: frame.size)
                elements.before!.layoutWith(frame: CGRect(
                    x: frame.minX + elements.before!.layoutMargins.left,
                    y: frame.minY + elements.before!.layoutMargins.top,
                    width: elementBeforeContentSize.width,
                    height: frame.height - verticalMargins(of: elements.before!)))
            }

            if elements.after != nil {
                let elementAfterContentSize = self.sizeThatFitsWithMargins(of: elements.after!, size: frame.size)
                elements.after!.layoutWith(frame: CGRect(
                    x: frame.minX + frame.width - elementAfterContentSize.width - elements.after!.layoutMargins.right,
                    y: frame.minY + elements.after!.layoutMargins.top,
                    width: elementAfterContentSize.width,
                    height: frame.height - verticalMargins(of: elements.after!)))
            }

            elements.content.layoutWith(frame: CGRect(
                x: elements.before != nil ?
                elements.before!.frame.maxX +
                    elements.before!.layoutMargins.right +
                    spacing +
                    elements.content.layoutMargins.left :
                frame.minX + elements.content.layoutMargins.left,
                y: frame.minY + elements.content.layoutMargins.top,
                width: frame.width - horizontalMargins(of: elements.content) -
                    (elements.before != nil ? self.widthWithMargins(of: elements.before!) + spacing : 0) -
                    (elements.after != nil ? self.widthWithMargins(of: elements.after!) + spacing : 0),
                height: frame.height - verticalMargins(of: elements.content)))

        case .vertical:
            if elements.before != nil {
                let elementBeforeContentSize = self.sizeThatFitsWithMargins(of: elements.before!, size: frame.size)
                elements.before!.layoutWith(frame: CGRect(
                    x: frame.minX + elements.before!.layoutMargins.left,
                    y: frame.minY + elements.before!.layoutMargins.top,
                    width: frame.width - horizontalMargins(of: elements.before!),
                    height: elementBeforeContentSize.height ))
            }

            if elements.after != nil {
                let elementAfterContentSize = self.sizeThatFitsWithMargins(of: elements.after!, size: frame.size)
                elements.after!.layoutWith(frame: CGRect(
                    x: frame.minX + elements.after!.layoutMargins.left,
                    y: frame.minY + frame.height - elementAfterContentSize.height - elements.after!.layoutMargins.bottom,
                    width: frame.width - horizontalMargins(of: elements.after!),
                    height: elementAfterContentSize.height))
            }

            elements.content.layoutWith(frame: CGRect(
                x: frame.minX + elements.content.layoutMargins.left,
                y: elements.before != nil ?
                elements.before!.frame.maxY +
                    elements.before!.layoutMargins.bottom +
                    spacing +
                    elements.content.layoutMargins.top :
                frame.minY + elements.content.layoutMargins.top,
                width: frame.width - horizontalMargins(of: elements.content),
                height: frame.height - verticalMargins(of: elements.content) -
                    (elements.before != nil ? self.heightWithMargins(of: elements.before!) + spacing : 0) -
                    (elements.after != nil  ? self.heightWithMargins(of: elements.after!) + spacing : 0)))
        }
    }

    public func sizeThatFits(_ size: CGSize) -> CGSize {
        var fit = CGSize()
        var optionalElements: [BayaLayoutable] = []
        if let startElement = elements.before {
            optionalElements.append(startElement)
        }
        if let endElement = elements.after {
            optionalElements.append(endElement)
        }

        switch orientation {
        case .horizontal:
            for element in optionalElements {
                let elementFit = sizeThatFitsWithMargins(of: element, size: size)
                fit.width += elementFit.width + horizontalMargins(of: element) + spacing
                fit.height = max(elementFit.height + verticalMargins(of: element), fit.height)
            }
            var contentFit = sizeThatFitsWithMargins(
                of: elements.content,
                size: CGSize(
                    width: size.width - fit.width,
                    height: size.height))
            contentFit.width += horizontalMargins(of: elements.content)
            contentFit.height += verticalMargins(of: elements.content)
            fit.width = max(size.width, fit.width)
            fit.height = max(contentFit.height, fit.height)
        case .vertical:
            for element in optionalElements {
                let elementFit = sizeThatFitsWithMargins(of: element, size: size)
                fit.width = max(elementFit.width + horizontalMargins(of: element), fit.width)
                fit.height += elementFit.height + verticalMargins(of: element) + spacing
            }
            var contentFit = sizeThatFitsWithMargins(
                of: elements.content,
                size: CGSize(
                    width: size.width,
                    height: size.height - fit.height))
            contentFit.width += horizontalMargins(of: elements.content)
            contentFit.height += verticalMargins(of: elements.content)
            fit.width = max(contentFit.width, fit.width)
            fit.height = max(size.height, fit.height)
        }
        return fit
    }
}

public extension BayaLayoutable {
    /**
        Gives this element a fixed sized container.
    */
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

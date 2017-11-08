//
// Copyright (c) 2016-2017 wag it GmbH.
// License: MIT
//

import Foundation
import UIKit

/**
    A Layout for a ScrollContainer and its content.
*/
public struct BayaScrollLayout: BayaLayout {
    public var bayaMargins: UIEdgeInsets
    public var frame: CGRect
    public let bayaModes: BayaLayoutOptions.Modes
    var orientation: BayaLayoutOptions.Orientation

    private var container: BayaScrollLayoutContainer
    private var content: BayaLayoutable
    private var contentMeasure: CGSize?

    init(
        content: BayaLayoutable,
        container: BayaScrollLayoutContainer,
        orientation: BayaLayoutOptions.Orientation,
        bayaMargins: UIEdgeInsets) {
        self.content = content
        self.container = container
        self.orientation = orientation
        self.bayaMargins = bayaMargins
        self.frame = CGRect()
        self.bayaModes = BayaLayoutOptions.Modes(
            width: content.bayaModes.width == .wrapContent && container.bayaModes.width == .wrapContent ?
                .wrapContent : .matchParent,
            height: content.bayaModes.height == .wrapContent && container.bayaModes.height == .wrapContent ?
                .wrapContent : .matchParent)
    }

    mutating public func layoutWith(frame: CGRect) {
        self.frame = frame
        let maximalAvailableContentSize = sizeForMeasurement(frame.size)
        let measuredContentSize = contentMeasure ?? content.sizeThatFits(maximalAvailableContentSize)
        let adjustedContentSize: CGSize
        switch orientation {
        case .horizontal:
            adjustedContentSize = CGSize(
                width: content.bayaModes.width == .wrapContent ?
                    measuredContentSize.width : max(
                        measuredContentSize.width,
                        frame.size.width - container.horizontalMargins - content.horizontalMargins),
                height: content.bayaModes.height == .wrapContent ?
                    measuredContentSize.height : frame.height - content.verticalMargins - container.verticalMargins)
        case .vertical:
            adjustedContentSize = CGSize(
                width: content.bayaModes.width == .wrapContent ?
                    measuredContentSize.width : frame.width - content.horizontalMargins - container.horizontalMargins,
                height: content.bayaModes.height == .wrapContent ?
                    measuredContentSize.height : max(
                        measuredContentSize.height,
                        frame.size.height - container.verticalMargins - content.verticalMargins)
            )
        }
        let bayaMargins = content.bayaMargins
        content.layoutWith(frame: CGRect(
            origin: CGPoint(
                x: bayaMargins.left,
                y: bayaMargins.top),
            size: adjustedContentSize))
        container.layoutWith(frame: frame.subtractMargins(ofElement: container))
        container.contentSize = adjustedContentSize.addMargins(ofElement: content)
    }

    mutating public func sizeThatFits(_ size: CGSize) -> CGSize {
        let measureSize = sizeForMeasurement(size)
        contentMeasure = content.sizeThatFits(measureSize)
        return CGSize(
            width: min(contentMeasure!.width + content.horizontalMargins + container.horizontalMargins, size.width),
            height: min(contentMeasure!.height + content.verticalMargins + container.verticalMargins, size.height))
    }

    private func sizeForMeasurement(_ size: CGSize) -> CGSize {
        let availableWidth: CGFloat
        let availableHeight: CGFloat
        switch orientation {
        case .horizontal:
            availableWidth = CGFloat.greatestFiniteMagnitude
            availableHeight = size.height - content.verticalMargins - container.verticalMargins
        case .vertical:
            availableWidth = size.width - content.horizontalMargins - container.horizontalMargins
            availableHeight = CGFloat.greatestFiniteMagnitude
        }
        return CGSize(width: availableWidth, height: availableHeight)
    }
}

public extension BayaLayoutable {
    /// Lays out the element as content of the given scroll container.
    /// - parameter container: Typically a `UIScrollView`. All of the element's views should be sub views
    ///   of the container.
    /// - parameter orientation: Determines the direction in which the element is allowed to extend past the
    ///   container. This is the direction that may be scrolled, if the element is large enough.
    /// - parameter bayaMargins: The margins around the container.
    /// - returns: A `BayaScrollLayout`.
    func layoutScrollContent(
        container: BayaScrollLayoutContainer,
        orientation: BayaLayoutOptions.Orientation = .vertical,
        bayaMargins: UIEdgeInsets = UIEdgeInsets.zero)
            -> BayaScrollLayout {
        return BayaScrollLayout(
            content: self,
            container: container,
            orientation: orientation,
            bayaMargins: bayaMargins)
    }
}

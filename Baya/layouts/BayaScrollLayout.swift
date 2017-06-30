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
    public var layoutMargins: UIEdgeInsets
    public var frame: CGRect
    public let layoutModes: BayaLayoutOptions.Modes
    var orientation: BayaLayoutOptions.Orientation

    private var container: BayaScrollLayoutContainer
    private var content: BayaLayoutable
    private var contentMeasure: CGSize?

    init(
        content: BayaLayoutable,
        container: BayaScrollLayoutContainer,
        orientation: BayaLayoutOptions.Orientation = .vertical,
        layoutMargins: UIEdgeInsets = UIEdgeInsets.zero) {
        self.content = content
        self.container = container
        self.orientation = orientation
        self.layoutMargins = layoutMargins
        self.frame = CGRect()
        self.layoutModes = BayaLayoutOptions.Modes(
            width: content.layoutModes.width == .wrapContent && container.layoutModes.width == .wrapContent ?
                .wrapContent : .matchParent,
            height: content.layoutModes.height == .wrapContent && container.layoutModes.height == .wrapContent ?
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
                width: content.layoutModes.width == .wrapContent ?
                    measuredContentSize.width : max(measuredContentSize.width, maximalAvailableContentSize.width),
                height: content.layoutModes.height == .wrapContent ?
                    measuredContentSize.height : frame.height - content.verticalMargins)
        case .vertical:
            adjustedContentSize = CGSize(
                width: content.layoutModes.width == .wrapContent ?
                    measuredContentSize.width : frame.width - content.horizontalMargins,
                height: content.layoutModes.height == .wrapContent ?
                    measuredContentSize.height : max(measuredContentSize.height, maximalAvailableContentSize.height)
            )
        }

        let minContainerWidth = measuredContentSize.width + content.horizontalMargins
        let minContainerHeight = measuredContentSize.height + content.verticalMargins
        let maxContainerWidth = frame.width - container.horizontalMargins
        let maxContainerHeight = frame.height - container.verticalMargins
        let containerSize = CGSize(
            width: container.layoutModes.width == .wrapContent && content.layoutModes.width == .wrapContent ?
                min(minContainerWidth, maxContainerWidth) : maxContainerWidth,
            height: container.layoutModes.height == .wrapContent && content.layoutModes.height == .wrapContent ?
                min(minContainerHeight, maxContainerHeight) : maxContainerHeight)

        content.layoutWith(frame: CGRect(
            origin: CGPoint(
                x: content.layoutMargins.left,
                y: content.layoutMargins.top),
            size: adjustedContentSize))
        container.layoutWith(frame: CGRect(
            origin: CGPoint(
                x: container.layoutMargins.left,
                y: container.layoutMargins.top),
            size: containerSize))
        container.contentSize = adjustedContentSize.addMargins(ofElement: content)
    }

    mutating public func sizeThatFits(_ size: CGSize) -> CGSize {
        contentMeasure = content.sizeThatFits(sizeForMeasurement(size))
        return CGSize(
            width: min(contentMeasure!.width + content.horizontalMargins, size.width),
            height: min(contentMeasure!.height + content.verticalMargins, size.height))
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
    func layoutScrollContent(
        container: BayaScrollLayoutContainer,
        orientation: BayaLayoutOptions.Orientation = .vertical,
        layoutMargins: UIEdgeInsets = UIEdgeInsets.zero)
            -> BayaScrollLayout {
        return BayaScrollLayout(
            content: self,
            container: container,
            orientation: orientation,
            layoutMargins: layoutMargins)
    }
}

//
// Copyright (c) 2016-2017 wag it GmbH.
// License: MIT
//

import Foundation
import UIKit

/**
    A layout that calculates the size of its content layoutable depending on the given frame,
    the number of pages, and an optional spacing. The container will be laid out according to the frame.
    This layout assumes that its child has the implicit layout mode .matchParent.
 */
public struct BayaPagedScrollLayout: BayaLayout {
    public var layoutMargins: UIEdgeInsets
    public var frame: CGRect
    var orientation: BayaLayoutOptions.Orientation
    var pages: Int
    var spacing: CGFloat

    private var container: BayaScrollLayoutContainer
    private var content: BayaLayoutable

    init(
        content: BayaLayoutable,
        container: BayaScrollLayoutContainer,
        pages: Int,
        spacing: CGFloat = 0,
        orientation: BayaLayoutOptions.Orientation = .horizontal,
        layoutMargins: UIEdgeInsets = UIEdgeInsets.zero) {
        self.content = content
        self.container = container
        self.pages = pages
        self.spacing = spacing
        self.orientation = orientation
        self.layoutMargins = layoutMargins
        self.frame = CGRect()
    }

    mutating public func layoutWith(frame: CGRect) {
        self.frame = frame

        let containerFrame = CGRect(
            x: frame.minX,
            y: frame.minY,
            width: orientation == .horizontal ? frame.width + spacing : frame.width,
            height: orientation == .vertical ? frame.height + spacing : frame.height)
        container.layoutWith(frame: containerFrame)

        let contentFrame = CGRect(
            x: 0,
            y: 0,
            width: orientation == .horizontal ?
            frame.width * CGFloat(pages) + spacing * CGFloat(pages - 1) : frame.width,
            height: orientation == .vertical ?
            frame.height * CGFloat(pages) + spacing * CGFloat(pages - 1) : frame.height)
        content.layoutWith(frame: contentFrame)

        container.contentSize = CGSize(
            // increase the contentSize for a trailing gutter (which won't be shown).
            width: orientation == .horizontal ? contentFrame.width + spacing : contentFrame.width,
            height: orientation == .vertical ? contentFrame.height + spacing : contentFrame.height)
    }

    public func sizeThatFits(_ size: CGSize) -> CGSize {
        // PagedScrollLayout always fits the given size
        return size
    }
}

public extension BayaLayoutable {
    /// Lays out the container element to fit the available size. The content element is laid out using a size which is
    /// defined by the container's size multiplied with the desired amount of pages.
    /// - parameter container: Typically a `UIScrollView`. All views contained in the content element should be subviews
    ///   of the container.
    /// - parameter pages: Determines the size of the content element.
    /// - parameter spacing: The gap between the pages.
    /// - parameter orientation: Determines if the pages are laid out in horizontal or vertical direction.
    /// - parameter layoutMargins: The layout's margins.
    /// - returns: A BayaPagedScrollLayout.
    func layoutPagedScrollContent(
        container: BayaScrollLayoutContainer,
        pages: Int,
        spacing: CGFloat = 0,
        orientation: BayaLayoutOptions.Orientation = .horizontal,
        layoutMargins: UIEdgeInsets = UIEdgeInsets.zero)
            -> BayaPagedScrollLayout {
        return BayaPagedScrollLayout(
            content: self,
            container: container,
            pages: pages,
            spacing: spacing,
            orientation: orientation,
            layoutMargins: layoutMargins)
    }
}

//
// Copyright (c) 2016-2017 wag it GmbH.
// License: MIT
//

import Foundation

/**
    A layout that calculates the size of its content layoutable depending on the given frame,
    the number of pages, and an optional gutter. The container will be laid out according to the frame.
 */
public struct PagedScrollLayout: BayaLayout {
    public var layoutMargins: UIEdgeInsets
    public var frame: CGRect
    var orientation: BayaLayoutOptions.Orientation
    var pages: Int
    var gutter: CGFloat

    private var container: PagedScrollLayoutContainer
    private var content: BayaLayoutable

    init(
        content: BayaLayoutable,
        container: PagedScrollLayoutContainer,
        pages: Int,
        gutter: CGFloat = 0,
        orientation: BayaLayoutOptions.Orientation = .horizontal,
        layoutMargins: UIEdgeInsets = UIEdgeInsets.zero) {

        self.content = content
        self.container = container
        self.pages = pages
        self.gutter = gutter
        self.orientation = orientation
        self.layoutMargins = layoutMargins
        self.frame = CGRect()
    }

    mutating public func layoutWith(frame: CGRect) {
        self.frame = frame

        let containerFrame = CGRect(
            x: frame.minX,
            y: frame.minY,
            width: orientation == .horizontal ? frame.width + gutter : frame.width,
            height: orientation == .vertical ? frame.height + gutter : frame.height)
        container.layoutWith(frame: containerFrame)

        let contentFrame = CGRect(
            x: 0,
            y: 0,
            width: orientation == .horizontal ?
            frame.width * CGFloat(pages) + gutter * CGFloat(pages - 1) : frame.width,
            height: orientation == .vertical ?
            frame.height * CGFloat(pages) + gutter * CGFloat(pages - 1) : frame.height)
        content.layoutWith(frame: contentFrame)

        container.contentSize = CGSize(
            // increase the contentSize for a trailing gutter (which won't be shown).
            width: orientation == .horizontal ? contentFrame.width + gutter : contentFrame.width,
            height: orientation == .vertical ? contentFrame.height + gutter : contentFrame.height)
    }

    public func sizeThatFits(_ size: CGSize) -> CGSize {
        // PagedScrollLayout always fits the given size
        return size
    }
}

/**
    Implement this protocol for the paged scroll layout container
 */
public protocol PagedScrollLayoutContainer {
    var contentSize: CGSize {get set}
    var bounds: CGRect {get}
    func layoutWith(frame: CGRect) -> Void
}

// MARK: UIKit specific extensions

extension UIScrollView: PagedScrollLayoutContainer {}

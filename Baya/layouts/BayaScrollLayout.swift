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
    var orientation: BayaLayoutOptions.Orientation

    private var container: ScrollLayoutContainer
    private var content: BayaLayoutable

    init(
        content: BayaLayoutable,
        container: ScrollLayoutContainer,
        orientation: BayaLayoutOptions.Orientation = .vertical,
        layoutMargins: UIEdgeInsets = UIEdgeInsets.zero) {
        self.content = content
        self.container = container
        self.orientation = orientation
        self.layoutMargins = layoutMargins
        self.frame = CGRect()
    }

    mutating public func layoutWith(frame: CGRect) {
        self.frame = frame

        let contentSize: CGSize = orientation == .horizontal ?
            content.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: frame.height)) :
            content.sizeThatFits(CGSize(width: frame.width, height: CGFloat.greatestFiniteMagnitude))

        content.layoutWith(frame: CGRect(
            origin: CGPoint(),
            size: contentSize))
        container.layoutWith(frame: CGRect(
            x: frame.origin.x + layoutMargins.left,
            y: frame.origin.y + layoutMargins.top,
            width: frame.width - layoutMargins.left - layoutMargins.right,
            height: frame.height - layoutMargins.top - layoutMargins.top))
        container.contentSize = contentSize
    }

    public func sizeThatFits(_ size: CGSize) -> CGSize {
        // ScrollLayout always fits the given frame
        return size
    }
}

/**
    Implement this protocol for the scroll layout container.
 */
public protocol ScrollLayoutContainer: class {
    var contentSize: CGSize { get set }
    func layoutWith(frame: CGRect) -> ()
}

extension UIScrollView: ScrollLayoutContainer {}

public extension BayaLayoutable {
    func layoutScrollContent(
        container: ScrollLayoutContainer,
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

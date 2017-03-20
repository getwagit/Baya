//
// Copyright (c) 2016-2017 wag it GmbH.
// License: MIT
//

import Foundation
import UIKit

/**
    Lays the wrapped element out so it matches its parent's size.
 */
public struct MatchParentLayout: BayaLayout {
    public var layoutMargins: UIEdgeInsets
    public var frame: CGRect

    private var element: BayaLayoutable
    private let matchParent: (width: Bool, height: Bool)

    init(
        element: BayaLayoutable,
        matchParent: (width: Bool, height: Bool),
        layoutMargins: UIEdgeInsets = UIEdgeInsets.zero) {
        self.element = element
        self.matchParent = matchParent
        self.layoutMargins = layoutMargins
        self.frame = CGRect()
    }

    mutating public func layoutWith(frame: CGRect) {
        self.frame = frame
        let size = sizeThatFitsWithMargins(of: element, size: frame.size)

        element.layoutWith(frame: CGRect(
            x: frame.minX + element.layoutMargins.left,
            y: frame.minY + element.layoutMargins.top,
            width: matchParent.width ? frame.width - self.horizontalMargins(of: element) : size.width,
            height: matchParent.height ? frame.height - self.verticalMargins(of: element) : size.height))
    }

    public func sizeThatFits(_ size: CGSize) -> CGSize {
        if matchParent.width && matchParent.height {
            return size
        }
        let fit = sizeThatFitsWithMargins(of: element, size: size)
        return CGSize(
            width: matchParent.width ? size.width :
            fit.width + element.layoutMargins.left + element.layoutMargins.right,
            height: matchParent.height ? size.height :
            fit.height + element.layoutMargins.top + element.layoutMargins.bottom)
    }
}


// MARK: Match Parent Shortcuts

public extension BayaLayoutable {
    func matchParentWidth() -> BayaLayoutable {
        return matchParent(width: true, height: false)
    }

    func matchParentHeight() -> BayaLayoutable {
        return matchParent(width: false, height: true)
    }

    func matchParent() -> BayaLayoutable {
        return matchParent(width: true, height: true)
    }

    func matchParent(
        width: Bool,
        height: Bool,
        layoutMargins: UIEdgeInsets = UIEdgeInsets.zero)
            -> BayaLayoutable {
        return MatchParentLayout(
            element: self,
            matchParent: (width: width, height: height),
            layoutMargins: layoutMargins)
    }
}

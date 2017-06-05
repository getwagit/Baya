//
// Copyright (c) 2016-2017 wag it GmbH.
// License: MIT
//

import Foundation
import UIKit

/**
    Lays the wrapped element out so it matches its parent's size.
 */
public struct BayaMatchParentLayout: BayaLayout {
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
        element.subtractMarginsAndLayoutWith(frame: frame)
    }

    public mutating func sizeThatFits(_ size: CGSize) -> CGSize {
        if matchParent.width && matchParent.height {
            return size
        }
        let fit = element.sizeThatFitsWithMargins(size)
        return CGSize(
            width: matchParent.width ? size.width : fit.width + element.horizontalMargins,
            height: matchParent.height ? size.height : fit.height + element.verticalMargins)
    }
}

public extension BayaLayoutable {
    func layoutMatchingParent(
        width: Bool,
        height: Bool,
        layoutMargins: UIEdgeInsets = UIEdgeInsets.zero)
            -> BayaMatchParentLayout {
        return BayaMatchParentLayout(
            element: self,
            matchParent: (width: width, height: height),
            layoutMargins: layoutMargins)
    }
}

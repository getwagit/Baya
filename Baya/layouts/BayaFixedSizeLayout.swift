//
// Copyright (c) 2016-2017 wag it GmbH.
// License: MIT
//

import Foundation
import UIKit

/**
    Wraps a layoutable and overrides layout modes by applying fixed sizes.
    Mirrors layout modes from its child.
*/
public struct BayaFixedSizeLayout: BayaLayout {
    public var layoutMargins = UIEdgeInsets.zero
    public var frame = CGRect()
    public var layoutModes: BayaLayoutModes {
        return element.layoutModes
    }
    private var element: BayaLayoutable
    private var measure: CGSize?
    private var fixedWidth: CGFloat?
    private var fixedHeight: CGFloat?

    init(
        element: BayaLayoutable,
        width: CGFloat?,
        height: CGFloat?) {
        self.fixedWidth = width
        self.fixedHeight = height
        self.element = element
    }

    mutating public func layoutWith(frame: CGRect) {
        self.frame = frame
        let size: CGSize;
        if let fixedHeight = fixedHeight, let fixedWidth = fixedWidth {
            size = CGSize(
                width: fixedWidth - element.horizontalMargins,
                height: fixedHeight - element.verticalMargins)
        } else {
            let defaultSize = calculateSizeForLayout(forChild: &element, cachedSize: measure, ownSize: frame.size)
            size = CGSize(
                width: fixedWidth?.subtract(element.horizontalMargins) ?? defaultSize.width,
                height: fixedHeight?.subtract(element.verticalMargins) ?? defaultSize.height)
        }

        element.layoutWith(frame: CGRect(
            origin: CGPoint(
                x: frame.origin.x + element.layoutMargins.left,
                y: frame.origin.y + element.layoutMargins.top),
            size: size))
    }

    public mutating func sizeThatFits(_ size: CGSize) -> CGSize {
        measure = element.sizeThatFitsWithMargins(size)
        return CGSize(
            width: fixedWidth ?? (measure!.width + element.horizontalMargins),
            height: fixedHeight ?? (measure!.height + element.verticalMargins))
    }
}

public extension BayaLayoutable {
    /**
        Gives this element a fixed sized container.
        Mirrors layout modes that are not fixed sizes from this element.
    */
    func layoutWithFixedSize(
        width: CGFloat?,
        height: CGFloat?)
            -> BayaFixedSizeLayout {
        return BayaFixedSizeLayout(
            element: self,
            width: width,
            height: height)
    }
}

private extension CGFloat {
    func subtract(_ other: CGFloat) -> CGFloat {
        return self - other
    }
}

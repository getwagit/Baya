//
// Copyright (c) 2016-2017 wag it GmbH.
// License: MIT
//

import Foundation
import UIKit

/**
    A layout that acts as a frame. It measures the largest dimensions and applies its frame to all children.
    It is suggested to use it with BayaGravityLayout as children.
*/
public struct BayaFrameLayout: BayaLayout, BayaLayoutIterator {
    public var layoutMargins: UIEdgeInsets
    public var frame: CGRect
    private var elements: [BayaLayoutable]
    private var measures = [CGSize]()

    init(
        elements: [BayaLayoutable],
        layoutMargins: UIEdgeInsets = UIEdgeInsets.zero) {
        self.elements = elements
        self.layoutMargins = layoutMargins
        self.frame = CGRect()
    }

    mutating public func layoutWith(frame: CGRect) {
        self.frame = frame
        iterate(&elements, measures) {
            e1, e2, e2s in
            let size = frame.size.subtractMargins(ofElement: e2)
            return CGRect(
                origin: CGPoint(
                    x: frame.minX + e2.layoutMargins.left,
                    y: frame.minY + e2.layoutMargins.top),
                size: size)
        }
    }

    public mutating func sizeThatFits(_ size: CGSize) -> CGSize {
        measures = measure(&elements, size: size)
        var maxWidth: CGFloat = 0
        var maxHeight: CGFloat = 0
        for i in 0..<elements.count {
            let element = elements[i]
            let elementSize = measures[i]
            maxWidth = max(maxWidth, elementSize.width + element.horizontalMargins)
            maxHeight = max(maxHeight, elementSize.height + element.verticalMargins)
        }
        return CGSize(width: maxWidth, height: maxHeight)
    }
}

public extension Sequence where Iterator.Element: BayaLayoutable {
    /**
        Measures the largest dimensions and applies its frame to all children.
        It is suggested to use it with BayaGravityLayout as children.
    */
    func layoutAsFrame(layoutMargins: UIEdgeInsets = UIEdgeInsets.zero) -> BayaFrameLayout {
        return BayaFrameLayout(elements: self.array(), layoutMargins: layoutMargins)
    }
}

public extension Sequence where Iterator.Element == BayaLayoutable {
    /**
        Measures the largest dimensions and applies its frame to all children.
        It is suggested to use it with BayaGravityLayout as children.
    */
    func layoutAsFrame(layoutMargins: UIEdgeInsets = UIEdgeInsets.zero) -> BayaFrameLayout {
        return BayaFrameLayout(elements: self.array(), layoutMargins: layoutMargins)
    }
}

//
// Copyright (c) 2017 wag it GmbH.
// License: MIT
//

import Foundation

/**
    Simple layout that stacks Layoutables.
    The frame of the Layoutables is not adjusted. BayaGroupLayout measures each element
    and applies the size it requested.
*/
public struct BayaGroupLayout: BayaLayout, BayaLayoutIterator {
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
            let size = saveMeasure(e2s: e2s, e2: &e2, size: frame.size)
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
        Groups the layoutables together.
        Layoutables are given the size that they request.
    */
    func layoutAsGroup(layoutMargins: UIEdgeInsets = UIEdgeInsets.zero) -> BayaGroupLayout {
        return BayaGroupLayout(elements: self.array(), layoutMargins: layoutMargins)
    }
}

public extension Sequence where Iterator.Element == BayaLayoutable {
    /**
        Groups the layoutables together.
        Layoutables are given the size that they request.
    */
    func layoutAsGroup(layoutMargins: UIEdgeInsets = UIEdgeInsets.zero) -> BayaGroupLayout {
        return BayaGroupLayout(elements: self.array(), layoutMargins: layoutMargins)
    }
}


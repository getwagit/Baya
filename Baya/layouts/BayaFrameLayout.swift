//
// Copyright (c) 2016-2017 wag it GmbH.
// License: MIT
//

import Foundation
import UIKit

/**
    Simple layout that stacks Layoutables.
*/
public struct BayaFrameLayout: BayaLayout, BayaLayoutIterator {
    public var layoutMargins: UIEdgeInsets
    public var frame: CGRect

    private var elements: [BayaLayoutable]

    init(
        elements: [BayaLayoutable],
        layoutMargins: UIEdgeInsets = UIEdgeInsets.zero) {
        self.elements = elements
        self.layoutMargins = layoutMargins
        self.frame = CGRect()
    }

    mutating public func layoutWith(frame: CGRect) {
        self.frame = frame
        iterate(&elements) {
            e1, e2 in
            return frame
        }
    }

    public func sizeThatFits(_ size: CGSize) -> CGSize {
        var maxWidth: CGFloat = 0
        var maxHeight: CGFloat = 0
        for element in elements {
            let elementSize = element.sizeThatFitsWithMargins(size)
            maxWidth = max(maxWidth, elementSize.width + element.horizontalMargins)
            maxHeight = max(maxHeight, elementSize.height + element.verticalMargins)
        }
        return CGSize(width: maxWidth, height: maxHeight)
    }
}

//
// Copyright (c) 2016-2017 wag it GmbH.
// License: MIT
//

import Foundation
import UIKit
import Oak

/**
    Simple layout that stacks Layoutables.
*/
struct FrameLayout: Layout, LayoutIterator {

    var layoutMargins: UIEdgeInsets
    var frame: CGRect

    private var elements: [Layoutable]

    init(
            elements: [Layoutable],
            layoutMargins: UIEdgeInsets = UIEdgeInsets.zero) {
        self.elements = elements
        self.layoutMargins = layoutMargins
        self.frame = CGRect()
    }

    mutating func layoutWith(frame: CGRect) {
        self.frame = frame
        iterate(&elements) {
            e1, e2 in
            return self.subtractMargins(frame: frame, element: e2)
        }
    }

    func sizeThatFits(_ size: CGSize) -> CGSize {
        var maxWidth: CGFloat = 0
        var maxHeight: CGFloat = 0
        for element in elements {
            let elementSize = self.sizeThatFitsWithMargins(of: element, size: size)
            maxWidth = max(maxWidth, elementSize.width + horizontalMargins(of: element))
            maxHeight = max(maxHeight, elementSize.height + verticalMargins(of: element))
        }
        return CGSize(width: maxWidth, height: maxHeight)
    }
}

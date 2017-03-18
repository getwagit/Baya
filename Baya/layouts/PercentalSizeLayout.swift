//
// Copyright (c) 2016-2017 wag it GmbH.
// License: MIT
//

import Foundation
import Oak

/**
    A Layout that uses a percental protion of the given size for measurement.
 */
struct PercentalSizeLayout: Layout {
    var layoutMargins: UIEdgeInsets
    var frame: CGRect

    private var element: Layoutable
    private var percentalWidth: CGFloat?
    private var percentalHeight: CGFloat?

    /**
        Initializes a PercentalSizeLayout
     
        - Parameters: 
            - element: The element to be laid out
            - width: The portion of the width that should be available for the element.
              A value of 0 equals 0%, a value of 1 equals 100%.
            - height: The portion of the height that should be available for the element.
              A value of 0 equals 0%, a value of 1 equals 100%.
            - layoutMargins: UIEdgeInsets defining the margins
     */
    init(
        element: Layoutable,
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        layoutMargins: UIEdgeInsets = UIEdgeInsets.zero) {
        self.element = element
        self.percentalWidth = width
        self.percentalHeight = height
        self.layoutMargins = layoutMargins
        self.frame = CGRect()
    }

    mutating func layoutWith(frame: CGRect) {
        self.frame = frame
        element.layoutWith(frame: subtractMargins(frame: frame, element: element))
    }

    func sizeThatFits(_ size: CGSize) -> CGSize {
        var fit = self.sizeThatFitsWithMargins(
            of: element,
            size: CGSize(
                width: size.width * (percentalWidth ?? 1),
                height: size.height * (percentalHeight ?? 1)))
        fit = addMargins(size: fit, element: element)

        return CGSize(
            width: (percentalWidth != nil) ? max(size.width * percentalWidth!, fit.width) : fit.width,
            height: (percentalHeight != nil) ? max(size.height * percentalHeight!, fit.height) : fit.height)
    }
}

//
// Copyright (c) 2016-2017 wag it GmbH.
// License: MIT
//

import Foundation
import UIKit

/**
    A Layout that uses a portion of the given size for measurement.
 */
public struct BayaProportionalSizeLayout: BayaLayout {
    public var layoutMargins: UIEdgeInsets
    public var frame: CGRect
    private var element: BayaLayoutable
    private var widthFactor: CGFloat?
    private var heightFactor: CGFloat?

    /**
        - Parameter element: The element to be laid out
        - Parameter width: The portion of the width that should be available for the element.
              A value of 0 equals 0%, a value of 1 equals 100%.
        - Parameter height: The portion of the height that should be available for the element.
              A value of 0 equals 0%, a value of 1 equals 100%.
        - Parameter layoutMargins: UIEdgeInsets defining the margins
     */
    init(
        element: BayaLayoutable,
        widthFactor: CGFloat? = nil,
        heightFactor: CGFloat? = nil,
        layoutMargins: UIEdgeInsets = UIEdgeInsets.zero) {
        self.element = element
        self.widthFactor = widthFactor
        self.heightFactor = heightFactor
        self.layoutMargins = layoutMargins
        self.frame = CGRect()
    }

    public mutating func layoutWith(frame: CGRect) {
        self.frame = frame
        element.layoutWith(frame: frame.subtractMargins(ofElement: element))
    }

    public mutating func sizeThatFits(_ size: CGSize) -> CGSize {
        let fit = element.sizeThatFitsWithMargins(CGSize(
                width: size.width * (widthFactor ?? 1),
                height: size.height * (heightFactor ?? 1)))
            .addMargins(ofElement: element)

        return CGSize(
            width: (widthFactor != nil) ? max(size.width * widthFactor!, fit.width) : fit.width,
            height: (heightFactor != nil) ? max(size.height * heightFactor!, fit.height) : fit.height)
    }
}

public extension BayaLayoutable {
    func layoutWithPortion(
        ofWidth: CGFloat? = nil,
        ofHeight: CGFloat? = nil,
        layoutMargins: UIEdgeInsets = UIEdgeInsets.zero)
            -> BayaProportionalSizeLayout {
        return BayaProportionalSizeLayout(
            element: self,
            widthFactor: ofWidth,
            heightFactor: ofHeight,
            layoutMargins: layoutMargins)
    }
}

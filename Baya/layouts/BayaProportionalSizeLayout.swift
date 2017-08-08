//
// Copyright (c) 2016-2017 wag it GmbH.
// License: MIT
//

import Foundation
import UIKit

/**
    A Layout that uses a portion of the given size for measurement and layout.
    Mirrors frame and layoutMargin from its child.
    Overrides layoutModes so that proportional axis are wrapContent.
 */
public struct BayaProportionalSizeLayout: BayaLayout {
    public var layoutMargins: UIEdgeInsets {
        return element.layoutMargins
    }
    public var frame: CGRect {
        return element.frame
    }
    private var element: BayaLayoutable
    private var measure: CGSize?
    public let layoutModes: BayaLayoutOptions.Modes
    private var widthFactor: CGFloat?
    private var heightFactor: CGFloat?

    init(
        element: BayaLayoutable,
        widthFactor: CGFloat? = nil,
        heightFactor: CGFloat? = nil) {
        self.element = element
        self.widthFactor = widthFactor.defaultToOneIfLarger()
        self.heightFactor = heightFactor.defaultToOneIfLarger()
        layoutModes = BayaLayoutOptions.Modes(
            width: widthFactor != nil ? .wrapContent : element.layoutModes.width,
            height: heightFactor != nil ? .wrapContent : element.layoutModes.height)
    }

    public mutating func layoutWith(frame: CGRect) {
        let size = calculateSizeForLayout(forChild: &element, cachedSize: measure, ownSize: frame.size)
        element.layoutWith(frame: CGRect(origin: frame.origin, size: size))
    }

    public mutating func sizeThatFits(_ size: CGSize) -> CGSize {
        let fit = element.sizeThatFits(size)
        measure = CGSize(
            width: widthFactor != nil ? size.width * widthFactor! : fit.width,
            height: heightFactor != nil ? size.height * heightFactor! : fit.height)
        return measure!
    }
}

private extension Optional where Wrapped == CGFloat {
    func defaultToOneIfLarger() -> CGFloat? {
        guard let value = self else {
            return nil
        }
        return value < 1 ? value : 1
    }
}

public extension BayaLayoutable {
    func layoutWithPortion(
        ofWidth: CGFloat? = nil,
        ofHeight: CGFloat? = nil)
            -> BayaProportionalSizeLayout {
        return BayaProportionalSizeLayout(
            element: self,
            widthFactor: ofWidth,
            heightFactor: ofHeight)
    }
}

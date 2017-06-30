//
// Copyright (c) 2016-2017 wag it GmbH.
// License: MIT
//

import Foundation
import UIKit

/**
    A Layout that uses a portion of the given size for measurement and layout.
    Mirrors frame and layoutMargin from its child.
    Overrides layoutModes so that proportional axis are matchParent.
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
            width: widthFactor != nil ? .matchParent : element.layoutModes.width,
            height: heightFactor != nil ? .matchParent : element.layoutModes.height)
    }

    public mutating func layoutWith(frame: CGRect) {
        let size = measure ?? element.sizeThatFits(sizeForMeasurement(frame.size))
        let frame = CGRect(
            origin: frame.origin,
            size: CGSize(
                width: widthFactor != nil ? frame.width * widthFactor! :
                    (element.layoutModes.width == .matchParent ? frame.width : size.width),
                height: heightFactor != nil ? frame.height * heightFactor! :
                    (element.layoutModes.height == .matchParent ? frame.height : size.height)))
        element.layoutWith(frame: frame)
    }

    public mutating func sizeThatFits(_ size: CGSize) -> CGSize {
        measure = element.sizeThatFits(sizeForMeasurement(size))
        return CGSize(
            width: (widthFactor != nil) ? measure!.width / widthFactor! : measure!.width,
            height: (heightFactor != nil) ? measure!.height / heightFactor! : measure!.height)
    }

    private func sizeForMeasurement(_ size: CGSize) -> CGSize {
        return CGSize(
            width: size.width * (widthFactor ?? 1),
            height: size.height * (heightFactor ?? 1))
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

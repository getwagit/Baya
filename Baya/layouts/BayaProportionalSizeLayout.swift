//
// Copyright (c) 2016-2017 wag it GmbH.
// License: MIT
//

import Foundation
import UIKit

/**
    A Layout that uses a portion of the given size for measurement and layout.
    Mirrors frame and layoutMargin from its child.
    Overrides bayaModes so that proportional axis are wrapContent.
 */
public struct BayaProportionalSizeLayout: BayaLayout {
    public var bayaMargins: UIEdgeInsets {
        return element.bayaMargins
    }
    public var frame: CGRect {
        return element.frame
    }
    private var element: BayaLayoutable
    private var measure: CGSize?
    public let bayaModes: BayaLayoutOptions.Modes
    private var widthFactor: CGFloat?
    private var heightFactor: CGFloat?

    init(
        element: BayaLayoutable,
        widthFactor: CGFloat?,
        heightFactor: CGFloat?) {
        self.element = element
        self.widthFactor = widthFactor.defaultToOneIfLarger()
        self.heightFactor = heightFactor.defaultToOneIfLarger()
        bayaModes = BayaLayoutOptions.Modes(
            width: widthFactor != nil ? .wrapContent : element.bayaModes.width,
            height: heightFactor != nil ? .wrapContent : element.bayaModes.height)
    }

    public mutating func layoutWith(frame: CGRect) {
        // Account for the edge case that this layout wasn't measured before laying it out
        let measure: CGSize = {
            guard let cachedMeasure = self.measure else {
                return calculateMeasure(frame.size)
            }
            return cachedMeasure
        }()
        
        // Only if a side has no portion factor and the layoutMode .matchParent it should actually
        // match the parent.
        let size = CGSize(
            width: widthFactor != nil || element.bayaModes.width == .wrapContent ?
                measure.width :
                frame.subtractMargins(ofElement: element).width,
            height: heightFactor != nil || element.bayaModes.height == .wrapContent ?
                measure.height :
                frame.subtractMargins(ofElement: element).height)

        element.layoutWith(frame: CGRect(origin: frame.origin, size: size))
    }

    public mutating func sizeThatFits(_ size: CGSize) -> CGSize {
        measure = calculateMeasure(size)
        return measure!
    }
    
    private mutating func calculateMeasure(_ size: CGSize) -> CGSize {
        let fit = element.sizeThatFits(size)
        return CGSize(
            width: widthFactor != nil ? size.width * widthFactor! : fit.width,
            height: heightFactor != nil ? size.height * heightFactor! : fit.height)
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
    /// Sets a portion of the available size as the size of the element.
    /// - parameter widthFactor: A factor from 0 to 1, which (multiplied by the available width) defines the width of the
    ///   element. If `nil` is passed as parameter the width is determined in accordance with the element's `bayaModes`.
    /// - parameter heightFactor: A factor from 0 to 1, which (multiplied by the available height) defines the height of
    ///   the element. If `nil` is passed as parameter the height is determined in accordance with the element's `bayaModes`.
    /// - returns: A `BayaProportionalSizeLayout`.
    func layoutWithPortion(
        ofWidth widthFactor: CGFloat? = nil,
        ofHeight heightFactor: CGFloat? = nil)
            -> BayaProportionalSizeLayout {
        return BayaProportionalSizeLayout(
            element: self,
            widthFactor: widthFactor,
            heightFactor: heightFactor)
    }
}

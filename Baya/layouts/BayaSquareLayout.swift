//
// Copyright (c) 2016-2017 wag it GmbH.
// License: MIT
//

import Foundation
import UIKit

/**
    Layout that uses only the reference side for measurement, or the smaller side if not specified.
    When setting the frame of its element, it uses the smaller side to ensure the square fits in the available space.
*/
public struct BayaSquareLayout: BayaLayout {
    public var layoutMargins: UIEdgeInsets
    public var frame: CGRect

    private var element: BayaLayoutable
    private let referenceSide: BayaLayoutOptions.Orientation?

    init(
        element: BayaLayoutable,
        referenceSide: BayaLayoutOptions.Orientation?,
        layoutMargins: UIEdgeInsets = UIEdgeInsets.zero) {
        self.element = element
        self.layoutMargins = layoutMargins
        self.referenceSide = referenceSide
        self.frame = CGRect()
    }

    mutating public func layoutWith(frame: CGRect) {
        self.frame = frame
        element.layoutWith(frame: frame.subtractMargins(ofElement: element).toSquare())
    }

    public mutating func sizeThatFits(_ size: CGSize) -> CGSize {
        let adjustedSize = size.subtractMargins(ofElement: element)
        switch referenceSide {
        case .some(.horizontal):
            return element.sizeThatFits(adjustedSize.toSquareFromWidth()).addMargins(ofElement: element)
        case .some(.vertical):
            return element.sizeThatFits(adjustedSize.toSquareFromHeight()).addMargins(ofElement: element)
        case .none:
            return element.sizeThatFits(adjustedSize.toSquare()).addMargins(ofElement: element)
        }
    }
}

private extension CGRect {
    func toSquare() -> CGRect {
        return CGRect(origin: origin, size: size.toSquare())
    }
}

private extension CGSize {
    func toSquareFromWidth() -> CGSize {
        return CGSize(width: width, height: width)
    }

    func toSquareFromHeight() -> CGSize {
        return CGSize(width: height, height: height)
    }

    func toSquare() -> CGSize {
        let sideLength = min(width, height)
        return CGSize(width: sideLength, height: sideLength)
    }
}

// MARK: Square shortcuts.

public extension BayaLayoutable {
    func layoutSquare(
        referenceSide: BayaLayoutOptions.Orientation,
        layoutMargins: UIEdgeInsets = UIEdgeInsets.zero)
            -> BayaSquareLayout {
        return BayaSquareLayout(
            element: self,
            referenceSide: referenceSide,
            layoutMargins: layoutMargins)
    }
}

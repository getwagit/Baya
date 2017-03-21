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
        element.layoutWith(frame: subtractMargins(frame: frame, element: element).toSquare())
    }

    public func sizeThatFits(_ size: CGSize) -> CGSize {
        let adjustedSize = subtractMargins(size: size, element: element)
        let margins: (CGSize) -> CGSize = { size in
            return self.addMargins(size: size, element: self.element)
        }
        switch referenceSide {
        case .some(.horizontal):
            let zeSize = margins(element.sizeThatFits(adjustedSize.toSquareFromWidth()))
            return zeSize
        case .some(.vertical):
            return margins(element.sizeThatFits(adjustedSize.toSquareFromHeight()))
        case .none:
            return margins(element.sizeThatFits(adjustedSize.toSquare()))
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

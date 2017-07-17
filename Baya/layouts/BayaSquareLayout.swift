//
// Copyright (c) 2016-2017 wag it GmbH.
// License: MIT
//

import Foundation
import UIKit

/**
    Layout that uses only the reference side for measurement, or the smaller side if not specified.
    Mirrors layoutMargins and frame of its child.
    When setting the frame of its element, it uses the smaller side to ensure the square fits in the available space.
*/
public struct BayaSquareLayout: BayaLayout {
    public var layoutMargins: UIEdgeInsets {
        return element.layoutMargins
    }
    public var frame: CGRect {
        return element.frame
    }
    public var layoutModes: BayaLayoutOptions.Modes {
        // BayaSquareLayout wants its parent to used the measured sizes.
        return BayaLayoutOptions.Modes.default
    }
    private var element: BayaLayoutable
    private let referenceSide: BayaLayoutOptions.Orientation?

    init(
        element: BayaLayoutable,
        referenceSide: BayaLayoutOptions.Orientation?) {
        self.element = element
        self.referenceSide = referenceSide
    }

    mutating public func layoutWith(frame: CGRect) {
        element.layoutWith(frame: CGRect(
            origin: frame.origin,
            size: squareSizeBasedOnReferenceSide(frame.size)))
    }

    public mutating func sizeThatFits(_ size: CGSize) -> CGSize {
        if referenceSide != nil {
            return squareSizeBasedOnReferenceSide(size)
        } else {
            let fit = element.sizeThatFits(size.toSquare())
            let bigSide = max(fit.height, fit.width)
            return CGSize(width: bigSide, height: bigSide)
        }
    }

    private func squareSizeBasedOnReferenceSide(_ size: CGSize) -> CGSize {
        switch referenceSide {
        case .some(.horizontal):
            return size.toSquareFromWidth()
        case .some(.vertical):
            return size.toSquareFromHeight()
        case .none:
            return size.toSquare()
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
    func layoutAsSquare() -> BayaSquareLayout {
        return BayaSquareLayout(
            element: self,
            referenceSide: nil)
    }

    func layoutAsSquare(referenceSide: BayaLayoutOptions.Orientation)
            -> BayaSquareLayout {
        return BayaSquareLayout(
            element: self,
            referenceSide: referenceSide)
    }
}

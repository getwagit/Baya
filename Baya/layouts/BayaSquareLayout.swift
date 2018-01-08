//
// Copyright (c) 2016-2017 wag it GmbH.
// License: MIT
//

import Foundation
import UIKit

/**
    Layout that uses only the reference side for measurement, or the bigger side if not specified.
    Mirrors bayaMargins and frame of its child.
    When setting the frame of its element, it uses the smaller side to ensure the square fits in the available space.
*/
public struct BayaSquareLayout: BayaLayout {
    public var bayaMargins: UIEdgeInsets {
        return element.bayaMargins
    }
    public var frame: CGRect {
        return element.frame
    }
    public var bayaModes: BayaLayoutOptions.Modes {
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
        let size = squareSizeBasedOnReferenceSide(frame.size)
        element.layoutWith(
            // A safety measure to ensure that this layout squares its element,
            // even if the given frame is a regular rectangle.
            frame: CGRect(
                origin: frame.origin,
                size: size))
    }

    public mutating func sizeThatFits(_ size: CGSize) -> CGSize {
        // If a reference side is specified
        // the square wants to match the available space on this side
        // and a square based on this referenceSide is returned.
        // When no reference side is specified the element is measured
        // and a square based on the bigger side is returned.
        if referenceSide != nil {
            return squareSizeBasedOnReferenceSide(size)
        } else {
            let fit = element.sizeThatFits(size.toSquare())
            return fit.toBigSquare()
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
    
    func toBigSquare() -> CGSize {
        let bigSide = max(height, width)
        return CGSize(width: bigSide, height: bigSide)
    }
}

// MARK: Square shortcuts.

public extension BayaLayoutable {
    /// Lays out the element as a square. The element's bigger side will be used to determine the size of the square.
    /// - returns: A `BayaSquareLayout`.
    func layoutAsSquare() -> BayaSquareLayout {
        return BayaSquareLayout(
            element: self,
            referenceSide: nil)
    }

    /// Lays out the element as a square.
    /// - parameter referenceSide: Specifies the side to base the square's size on.
    /// - returns: A `BayaSquareLayout`.
    func layoutAsSquare(referenceSide: BayaLayoutOptions.Orientation)
            -> BayaSquareLayout {
        return BayaSquareLayout(
            element: self,
            referenceSide: referenceSide)
    }
}

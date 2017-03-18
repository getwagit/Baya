//
// Created by Markus Riegel on 08.12.16.
// Copyright (c) 2016 wag it GmbH. All rights reserved.
//

import Foundation
import UIKit
import Oak

/**
    Layout that uses only the reference side for measurement, or the smaller side if not specified.
    When setting the frame of its element, it uses the smaller side to ensure the square fits in the available space.
*/
struct SquareLayout: Layout {
    var layoutMargins: UIEdgeInsets
    var frame: CGRect

    private var element: Layoutable
    private let referenceSide: LayoutOptions.Orientation?

    init(
        element: Layoutable,
        referenceSide: LayoutOptions.Orientation?,
        layoutMargins: UIEdgeInsets = UIEdgeInsets.zero) {
        self.element = element
        self.layoutMargins = layoutMargins
        self.referenceSide = referenceSide
        self.frame = CGRect()
    }

    mutating func layoutWith(frame: CGRect) {
        self.frame = frame
        element.layoutWith(frame: subtractMargins(frame: frame, element: element).toSquare())
    }

    func sizeThatFits(_ size: CGSize) -> CGSize {
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

extension Layoutable {
    func square(basedOn referenceSide: LayoutOptions.Orientation) -> Layoutable {
        return SquareLayout(
            element: self,
            referenceSide: referenceSide)
    }
}
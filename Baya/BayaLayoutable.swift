//
// Copyright (c) 2016-2017 wag it GmbH.
// License: MIT
//

import Foundation
import UIKit

/**
    Something that you can layout.
    Can be a UIView or another Layout.
*/
public protocol BayaLayoutable {
    var layoutMargins: UIEdgeInsets {get}
    var frame: CGRect {get}
    var measureModes: BayaMeasureModes {get}
    mutating func sizeThatFits(_ size: CGSize) -> CGSize
    mutating func layoutWith(frame: CGRect)
}

/**
    Public helper.
*/
public extension BayaLayoutable {
    var measureModes: BayaMeasureModes {
        return defaultMeasureModes
    }
}

/**
    Internal helper.
*/
internal extension BayaLayoutable {
    var verticalMargins: CGFloat {
        return layoutMargins.top + layoutMargins.bottom
    }

    var horizontalMargins: CGFloat {
        return layoutMargins.left + layoutMargins.right
    }

    var heightWithMargins: CGFloat {
        return frame.height + verticalMargins
    }

    var widthWithMargins: CGFloat {
        return frame.width + horizontalMargins
    }

    mutating func sizeThatFitsWithMargins(_ size: CGSize) -> CGSize {
        return sizeThatFits(size.subtractMargins(ofElement: self))
    }

    mutating func subtractMarginsAndLayoutWith(frame: CGRect) {
        layoutWith(frame: frame.subtractMargins(ofElement: self))
    }
}

// MARK: Sequence Helper

/**
    Converts any sequence into an array if it is not an Array already.
    Needed because we ca not extend an Array with BayaLayoutable as generic parameter.
*/
internal extension Sequence where Iterator.Element == BayaLayoutable {
    func array() -> [BayaLayoutable] {
        if let array = self as? [BayaLayoutable] {
            return array
        }
        return Array(self)
    }
}

/**
    Upcast a sequence of a type that implements BayaLayoutable.
    And convert to Array.
*/
internal extension Sequence where Iterator.Element: BayaLayoutable {
    func array() -> [BayaLayoutable] {
        if let array = self as? [Iterator.Element] {
            return upcast(array: array)
        }
        return upcast(array: Array(self))
    }

    func upcast<T: BayaLayoutable>(array: [T]) -> [BayaLayoutable] {
        return array.map { $0 as BayaLayoutable }
    }
}

// MARK: UIKit specific extensions

/**
    Apply LayoutTarget to UIView.
*/
extension UIView: BayaLayoutable {
    public func layoutWith(frame: CGRect) {
        setFrameSafely(frame)
    }
}

/**
    Helper for safely setting the frame on LayoutTargets.
*/
internal extension UIView {
    /**
        Use this method to set a frame safely if other transformations might have been applied.
        See https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIView_Class/#//apple_ref/occ/instp/UIView/frame

        - Parameter frame: The same frame you would normally set via LayoutTarget.frame .
    */
    func setFrameSafely(_ frame: CGRect) {
        if transform == CGAffineTransform.identity {
            self.frame = frame
        } else {
            let bounds = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
            self.bounds = bounds
            self.center = CGPoint(x: frame.minX + bounds.midX, y: frame.minY + bounds.midY)
        }
    }
}

// MARK: CGRect and CGSize

internal extension CGSize {
    func subtractMargins(ofElement element: BayaLayoutable) -> CGSize {
        return CGSize(
            width: max(width - element.horizontalMargins, 0),
            height: max(height - element.verticalMargins, 0))
    }

    func addMargins(ofElement element: BayaLayoutable) -> CGSize {
        return CGSize(
            width: width + element.horizontalMargins,
            height: height + element.verticalMargins)
    }
}

internal extension CGRect {
    func subtractMargins(ofElement element: BayaLayoutable) -> CGRect {
        return CGRect(
            origin: CGPoint(
                x: minX + element.layoutMargins.left,
                y: minY + element.layoutMargins.top),
            size: size.subtractMargins(ofElement: element))
    }
}



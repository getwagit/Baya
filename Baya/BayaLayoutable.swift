//
// Copyright (c) 2016-2017 wag it GmbH.
// License: MIT
//

import Foundation
import UIKit
import Oak

/**
    Something that you can layout.
    Can be a UIView or another Layout.
*/
public protocol BayaLayoutable {
    var layoutMargins: UIEdgeInsets {get}
    var frame: CGRect {get}
    func sizeThatFits(_ size: CGSize) -> CGSize
    mutating func layoutWith(frame: CGRect)
}

// MARK: UIKit specific extensions

/**
    Apply LayoutTarget to UIView.
*/
public extension UIView: BayaLayoutable {
    func layoutWith(frame: CGRect) {
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


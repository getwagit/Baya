//
// Created by Markus Riegel on 31.08.16.
// Copyright (c) 2016 wag it GmbH. All rights reserved.
//

import Foundation
import UIKit
import Oak

/**
    Something that you can layout.
    Can be a UIView or another Layout.
*/
protocol Layoutable {
    var layoutMargins: UIEdgeInsets {get}
    var frame: CGRect {get}
    func sizeThatFits(_ size: CGSize) -> CGSize
    mutating func layoutWith(frame: CGRect)
}


// MARK: UIKit specific extensions

/**
    Helper for safely setting the frame on LayoutTargets.
*/
extension UIView {
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

/**
    Apply LayoutTarget to UIView.
*/
extension UIView: Layoutable {
    func layoutWith(frame: CGRect) {
        setFrameSafely(frame)
    }
}

//
// Copyright (c) 2016-2017 wag it GmbH.
// License: MIT
//

import Foundation
import UIKit

/**
    Protocol for any layout.
*/
public protocol BayaLayout: BayaLayoutable {}

/**
    Methods just for the layout!
*/
public extension BayaLayout {
    /**
        Kick off the layout routine of the root element.
        Only call this method on the root element.
        Measures child layoutables but tries to keep them within the frame.
    */
    mutating public func startLayout(with frame: CGRect) {
        let origin = frame.origin
        let measuredSize = self.sizeThatFitsWithMargins(frame.size).addMargins(ofElement: self)
        let size = CGSize(
            width: min(frame.size.width, measuredSize.width),
            height: min(frame.size.width, measuredSize.width))
        self.layoutWith(frame: CGRect(
            origin: origin,
            size: size))
    }
}




// ------------------------------
// Deprecate below here!


///**
//    Extension for working with margins.
//    Keep margin related logic away from the Layoutable!
//*/
//internal extension BayaLayout {
//    /**
//        Run sizeThatFits but subtract the elements margins first.
//
//        - Parameter element: The element to call sizeThatFits on.
//        - Parameter size: Available size for layout.
//    */
//    mutating func sizeThatFitsWithMargins(of element: inout BayaLayoutable, size: CGSize) -> CGSize {
//        return element.sizeThatFits(subtractMargins(size: size, element: element))
//    }
//
//    /**
//        Convenience method for the height with margins!
//    */
//    func heightWithMargins(of element: BayaLayoutable) -> CGFloat {
//        return element.frame.height + element.layoutMargins.top + element.layoutMargins.bottom
//    }
//
//    /**
//        Convenience method for width with margins!
//    */
//    func widthWithMargins(of element: BayaLayoutable) -> CGFloat {
//        return element.frame.width + element.layoutMargins.left + element.layoutMargins.right
//    }
//
//    /**
//        Convenience method for horizontal margins!
//     */
//    func horizontalMargins(of element: BayaLayoutable) -> CGFloat {
//        return element.layoutMargins.left + element.layoutMargins.right
//    }
//
//    /**
//        Convenience method for vertical margins!
//     */
//    func verticalMargins(of element: BayaLayoutable) -> CGFloat {
//        return element.layoutMargins.top + element.layoutMargins.bottom
//    }
//
//    /**
//        Subtract the margins of a given element from the size.
//    */
//    func subtractMargins(size: CGSize, element: BayaLayoutable) -> CGSize {
//        return CGSize(
//            width: max(size.width - element.layoutMargins.left - element.layoutMargins.right, 0),
//            height: max(size.height - element.layoutMargins.top - element.layoutMargins.bottom, 0))
//    }
//
//    /**
//        Subtract the margins of a given element from the frame.
//        This also repositions the frame.
//    */
//    func subtractMargins(frame: CGRect, element: BayaLayoutable) -> CGRect {
//        return CGRect(
//            origin: CGPoint(
//                x: frame.minX + element.layoutMargins.left,
//                y: frame.minY + element.layoutMargins.top),
//            size: subtractMargins(size: frame.size, element: element))
//    }
//
//    /**
//        Adds the margins of an element to the given size.
//    */
//    func addMargins(size: CGSize, element: BayaLayoutable) -> CGSize {
//        return CGSize(
//            width: size.width + element.layoutMargins.left + element.layoutMargins.right,
//            height: size.height + element.layoutMargins.top + element.layoutMargins.bottom)
//    }
//}

//
// Created by Markus Riegel on 25.08.16.
// Copyright (c) 2016 wag it GmbH. All rights reserved.
//

import Foundation
import UIKit
import Oak

/**
    Protocol for any layout.
*/
protocol Layout: Layoutable {}

/**
    Extension for working with margins.
    Keep margin related logic away from the Layoutable!
*/
extension Layout {
    /**
        Run sizeThatFits but subtract the elements margins first.

        - Parameter element: The element to call sizeThatFits on.
        - Parameter size: Available size for layout.
    */
    func sizeThatFitsWithMargins(of element: Layoutable, size: CGSize) -> CGSize {
        return element.sizeThatFits(subtractMargins(size: size, element: element))
    }

    /**
        Convenience method for the height with margins!
    */
    func heightWithMargins(of element: Layoutable) -> CGFloat {
        return element.frame.height + element.layoutMargins.top + element.layoutMargins.bottom
    }

    /**
        Convenience method for width with margins!
    */
    func widthWithMargins(of element: Layoutable) -> CGFloat {
        return element.frame.width + element.layoutMargins.left + element.layoutMargins.right
    }
    
    /**
        Convenience method for horizontal margins!
     */
    func horizontalMargins(of element: Layoutable) -> CGFloat {
        return element.layoutMargins.left + element.layoutMargins.right
    }
    
    /**
        Convenience method for vertical margins!
     */
    func verticalMargins(of element: Layoutable) -> CGFloat {
        return element.layoutMargins.top + element.layoutMargins.bottom
    }

    /**
        Subtract the margins of a given element from the size.
    */
    func subtractMargins(size: CGSize, element: Layoutable) -> CGSize {
        return CGSize(
            width: max(size.width - element.layoutMargins.left - element.layoutMargins.right, 0),
            height: max(size.height - element.layoutMargins.top - element.layoutMargins.bottom, 0))
    }

    /**
        Subtract the margins of a given element from the frame.
        This also repositions the frame.
    */
    func subtractMargins(frame: CGRect, element: Layoutable) -> CGRect {
        return CGRect(
            origin: CGPoint(
                x: frame.minX + element.layoutMargins.left,
                y: frame.minY + element.layoutMargins.top),
            size: subtractMargins(size: frame.size, element: element))
    }

    /**
        Adds the margins of an element to the given size.
    */
    func addMargins(size: CGSize, element: Layoutable) -> CGSize {
        return CGSize(
            width: size.width + element.layoutMargins.left + element.layoutMargins.right,
            height: size.height + element.layoutMargins.top + element.layoutMargins.bottom)
    }
}

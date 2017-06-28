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
        let origin = CGPoint(
            x: frame.origin.x + self.layoutMargins.left,
            y: frame.origin.y + self.layoutMargins.top)
        let combinedSize = combineSizeForLayout(
            for: self,
            wrappingSize: self.sizeThatFitsWithMargins(frame.size),
            matchingSize: frame.size.subtractMargins(ofElement: self))
        let size = CGSize(
            width: min(frame.width, combinedSize.width),
            height: min(frame.height, combinedSize.height))

        self.layoutWith(frame: CGRect(
            origin: origin,
            size: size))
    }
}

/**
    Internal helper.
*/
internal extension BayaLayout {
    /**
        Measure or remeasure the size of a child element.
     
        - Parameter forChildElement: The element to measure. This element will be modified in the process.
        - Parameter cachedMeasuredSize: If available supply the size that was measured and cached during the measure pass.
        - Parameter availableSize: The size available, most of time the size of the frame.
    */
    func calculateSizeForLayout(
        forChild element: inout BayaLayoutable,
        cachedSize measuredSize: CGSize?,
        ownSize availableSize: CGSize)
            -> CGSize {
        return combineSizeForLayout(
            for: element,
            wrappingSize: measuredSize ?? element.sizeThatFitsWithMargins(availableSize),
            matchingSize: availableSize.subtractMargins(ofElement: element))
    }

    /**
        Combines two sizes based on the measure modes defined by the element.

        - Parameter forElement: The element that holds the relevant measure modes.
        - Parameter wrappingSize: The measured size of the element.
        - Parameter matchingSize: The size of the element when matching the parent.
    */
    func combineSizeForLayout(
        `for` element: BayaLayoutable,
        wrappingSize: CGSize,
        matchingSize: CGSize) -> CGSize {
        return CGSize(
            width: element.layoutModes.width == .matchParent ? matchingSize.width : wrappingSize.width,
            height: element.layoutModes.height  == .matchParent ? matchingSize.height : wrappingSize.height)
    }
}

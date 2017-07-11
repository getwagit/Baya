//
// Copyright (c) 2017 wag it GmbH.
// License: MIT
//

import Foundation
import Baya

class TestLayoutable: BayaLayoutable {
    let width: CGFloat
    let height: CGFloat
    let layoutModes: BayaLayoutOptions.Modes
    var frame = CGRect()
    var layoutMargins = UIEdgeInsets.zero
    
    init(
        width: CGFloat = 50,
        height: CGFloat = 50,
        layoutModes: BayaLayoutOptions.Modes? = nil) {
        self.width = width
        self.height = width
        self.layoutModes = layoutModes ?? BayaLayoutOptions.Modes(width: .wrapContent, height: .wrapContent)
    }
    
    convenience init(
        sideLength: CGFloat,
        layoutModes: BayaLayoutOptions.Modes? = nil) {
        self.init(width: sideLength, height: sideLength, layoutModes: layoutModes)
    }

    func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(
            width: self.width,
            height: self.height)
    }

    func layoutWith(frame: CGRect) {
        self.frame = frame
    }

    func m(_ top: CGFloat, _ left: CGFloat, _ bottom: CGFloat, _ right: CGFloat) {
        layoutMargins = UIEdgeInsets(
            top: top,
            left: left,
            bottom: bottom,
            right: right)
    }
}

class TestScrollLayoutContainer: TestLayoutable, BayaScrollLayoutContainer {
    var contentSize: CGSize = CGSize()
    var bounds: CGRect {
        return CGRect(origin: CGPoint(), size: frame.size)
    }
}

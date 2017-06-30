//
// Copyright (c) 2017 wag it GmbH.
// License: MIT
//

import Foundation
import Baya

class TestLayoutable: BayaLayoutable {
    let sideLength: CGFloat
    let layoutModes: BayaLayoutModes
    var frame = CGRect()
    var layoutMargins = UIEdgeInsets.zero

    init(
        sideLength: CGFloat = 50,
        layoutModes: BayaLayoutModes? = nil) {
        self.sideLength = sideLength
        self.layoutModes = layoutModes ?? BayaLayoutModes(width: .wrapContent, height: .wrapContent)
    }

    func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(
            width: self.sideLength,
            height: self.sideLength)
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
        return self.frame
    }
}

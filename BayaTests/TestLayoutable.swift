//
// Copyright (c) 2017 wag it GmbH.
// License: MIT
//

import Foundation
import Baya

class TestLayoutable: BayaLayoutable {
    let width: CGFloat
    let height: CGFloat
    let bayaModes: BayaLayoutOptions.Modes
    var frame = CGRect()
    var bayaMargins = UIEdgeInsets.zero
    
    init(
        width: CGFloat = 50,
        height: CGFloat = 50,
        bayaModes: BayaLayoutOptions.Modes? = nil) {
        self.width = width
        self.height = height
        self.bayaModes = bayaModes ?? BayaLayoutOptions.Modes(width: .wrapContent, height: .wrapContent)
    }
    
    convenience init(
        sideLength: CGFloat,
        bayaModes: BayaLayoutOptions.Modes? = nil) {
        self.init(width: sideLength, height: sideLength, bayaModes: bayaModes)
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
        bayaMargins = UIEdgeInsets(
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

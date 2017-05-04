//
// Copyright (c) 2017 wag it GmbH.
// License: MIT
//

import Foundation
import XCTest
@testable import Baya

class BayaOriginResetTests: XCTestCase {
    var l: TestLayoutable!
    let layoutRect = CGRect(x: 3, y: 4, width: 300, height: 400)

    override func setUp() {
        super.setUp()
        l = TestLayoutable()
        l.m(1, 2, 3, 4)
    }

    override func tearDown() {
        super.tearDown()
        l = nil
    }

    func testMeasure() {
        var layout = l.layoutResetOrigin()
        let size = layout.sizeThatFits(layoutRect.size)
        XCTAssertEqual(
            size,
            CGSize(
                width: TestLayoutable.sideLength + l.horizontalMargins,
                height: TestLayoutable.sideLength + l.verticalMargins),
            "size does not match")
    }

    func testResetsOrigin() {
        var layout = l.layoutResetOrigin()
        l.frame.origin.x = 20;
        l.frame.origin.y = 31;
        layout.layoutWith(frame: layoutRect)
        XCTAssertEqual(
            l.frame,
            CGRect(
                x: 0,
                y: 0,
                width: TestLayoutable.sideLength,
                height: TestLayoutable.sideLength))
    }
}

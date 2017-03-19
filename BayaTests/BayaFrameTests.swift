//
// Copyright (c) 2017 wag it GmbH.
// License: MIT
//

import Foundation

import XCTest
@testable import Baya

class BayaFrameTests: XCTestCase {
    var l1: TestLayoutable!
    var l2: TestLayoutable!
    var l3: TestLayoutable!

    override func setUp() {
        super.setUp()
        l1 = TestLayoutable()
        l2 = TestLayoutable()
        l3 = TestLayoutable()

        l1.layoutMargins = UIEdgeInsets(
            top: 8,
            left: 7,
            bottom: 4,
            right: 3)
        l2.layoutMargins = UIEdgeInsets(
            top: 20,
            left: 50,
            bottom: 23,
            right: 12)
        l3.layoutMargins = UIEdgeInsets.zero
    }

    override func tearDown() {
        super.tearDown()
        l1 = nil
        l2 = nil
        l3 = nil
    }

    func testEmptyArray() {
        var layout = [TestLayoutable]().layoutFrame()
        layout.layoutWith(frame: CGRect())
        XCTAssert(true) // Does not crash.
    }

    func testSizes() {
        var layout = [l1, l2, l3]
            .layoutFrame()

        layout.layoutWith(
            frame: CGRect(
                x: 5,
                y: 10,
                width: 300,
                height: 300))

        XCTAssertEqual(l1.frame, CGRect(
            x: 5 + l1.layoutMargins.left,
            y: 10 + l1.layoutMargins.top,
            width: 300 - l1.horizontalMargins,
            height: 300 - l1.verticalMargins),
            "unexpected l1 frame")
        XCTAssertEqual(l2.frame, CGRect(
            x: 5 + l2.layoutMargins.left,
            y: 10 + l2.layoutMargins.top,
            width: 300 - l2.horizontalMargins,
            height: 300 - l2.verticalMargins),
            "unexpected l2 frame")
        XCTAssertEqual(l3.frame, CGRect(
            x: 5 + l3.layoutMargins.left,
            y: 10 + l3.layoutMargins.top,
            width: 300 - l3.horizontalMargins,
            height: 300 - l3.verticalMargins),
            "unexpected l3 frame")
    }

    func testMeasures() {
        let layout = [l1, l2, l3]
            .layoutFrame()
        let size = layout.sizeThatFits(CGSize(
            width: 300,
            height: 200))

        // l2 has the biggest margins and should define the size.
        XCTAssertEqual(size, CGSize(
            width: TestLayoutable.sideLength + l2.horizontalMargins,
            height: TestLayoutable.sideLength + l2.verticalMargins),
            "sizes don't match")
    }
}

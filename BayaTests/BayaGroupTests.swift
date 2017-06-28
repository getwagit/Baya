//
// Copyright (c) 2017 wag it GmbH.
// License: MIT
//

import Foundation

import XCTest
@testable import Baya

class BayaGroupTests: XCTestCase {
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
        var layout = [TestLayoutable]().layoutAsGroup()
        layout.startLayout(
            with: CGRect())
        XCTAssert(true) // Does not crash.
    }

    func testSizes() {
        var layout = [l1, l2, l3]
            .layoutAsGroup()
        let layoutRect = CGRect(
            x: 5,
            y: 10,
            width: 300,
            height: 300)
        layout.startLayout(with: layoutRect)

        XCTAssertEqual(l1.frame, CGRect(
            x: layoutRect.origin.x + l1.layoutMargins.left,
            y: layoutRect.origin.y + l1.layoutMargins.top,
            width: l1.sideLength,
            height: l1.sideLength),
            "unexpected l1 frame")
        XCTAssertEqual(l2.frame, CGRect(
            x: layoutRect.origin.x + l2.layoutMargins.left,
            y: layoutRect.origin.y + l2.layoutMargins.top,
            width: l2.sideLength,
            height: l2.sideLength),
            "unexpected l2 frame")
        XCTAssertEqual(l3.frame, CGRect(
            x: layoutRect.origin.x + l3.layoutMargins.left,
            y: layoutRect.origin.y + l3.layoutMargins.top,
            width: l3.sideLength,
            height: l3.sideLength),
            "unexpected l3 frame")
    }

    func testMeasures() {
        var layout = [l1, l2, l3]
            .layoutAsGroup()
        let size = layout.sizeThatFits(CGSize(
            width: 300,
            height: 200))

        // l2 has the biggest margins and should define the size.
        XCTAssertEqual(size, CGSize(
            width: l2.sideLength + l2.horizontalMargins,
            height: l2.sideLength + l2.verticalMargins),
            "sizes don't match")
    }
}

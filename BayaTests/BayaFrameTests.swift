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
        l1 = TestLayoutable(sideLength: 30)
        l2 = TestLayoutable(sideLength: 90)
        l3 = TestLayoutable(sideLength: 60)

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
        var layout = [TestLayoutable]().layoutAsFrame()
        layout.startLayout(
            with: CGRect())
        XCTAssert(true) // Does not crash.
    }

    func testSizesWrappingContent() {
        var layout = [l1, l2, l3]
            .layoutAsFrame()
        let layoutRect = CGRect(
            x: 5,
            y: 10,
            width: 300,
            height: 300)
        layout.startLayout(with: layoutRect)

        XCTAssertEqual(l2.frame, CGRect(
            x: layoutRect.origin.x + l2.layoutMargins.left,
            y: layoutRect.origin.y + l2.layoutMargins.top,
            width: l2.sideLength,
            height: l2.sideLength),
            "unexpected l2 frame")
        XCTAssertEqual(l1.frame, CGRect(
            x: layoutRect.origin.x + l1.layoutMargins.left,
            y: layoutRect.origin.y + l1.layoutMargins.top,
            width: l1.sideLength,
            height: l1.sideLength),
            "unexpected l1 frame")
        XCTAssertEqual(l3.frame, CGRect(
            x: layoutRect.origin.x + l3.layoutMargins.left,
            y: layoutRect.origin.y + l3.layoutMargins.top,
            width: l3.sideLength,
            height: l3.sideLength),
            "unexpected l3 frame")
    }

    // TODO: Use own test layoutable instead of match parent to keep this test separated!
//    func testSizesMatchingParent() {
//        var layout = [l1.layoutMatchingParent(), l2.layoutMatchingParent(), l3.layoutMatchingParent()]
//            .layoutAsFrame()
//        let layoutRect = CGRect(
//            x: 5,
//            y: 10,
//            width: 300,
//            height: 300)
//        layout.startLayout(with: layoutRect)
//
//        XCTAssertEqual(l2.frame, CGRect(
//            x: layoutRect.origin.x + l2.layoutMargins.left,
//            y: layoutRect.origin.y + l2.layoutMargins.top,
//            width: TestLayoutable.sideLength,
//            height: TestLayoutable.sideLength),
//            "unexpected l2 frame")
//        // Frame 2 with its margins is the biggest.
//        // So all other frames sizes should be adjusted accordingly.
//        XCTAssertEqual(l1.frame, CGRect(
//            x: layoutRect.origin.x + l1.layoutMargins.left,
//            y: layoutRect.origin.y + l1.layoutMargins.top,
//            width: TestLayoutable.sideLength + l2.horizontalMargins - l1.horizontalMargins,
//            height: TestLayoutable.sideLength + l2.verticalMargins - l1.verticalMargins),
//            "unexpected l1 frame")
//        XCTAssertEqual(l3.frame, CGRect(
//            x: layoutRect.origin.x + l3.layoutMargins.left,
//            y: layoutRect.origin.y + l3.layoutMargins.top,
//            width: TestLayoutable.sideLength + l2.horizontalMargins - l3.horizontalMargins,
//            height: TestLayoutable.sideLength + l2.verticalMargins - l3.verticalMargins),
//            "unexpected l3 frame")
//    }

    func testMeasures() {
        var layout = [l1, l2, l3]
            .layoutAsFrame()
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

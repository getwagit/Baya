//
// Copyright (c) 2017 wag it GmbH.
// License: MIT
//

import XCTest
@testable import Baya

class BayaEqualSegmentsTests: XCTestCase {
    var l1: TestLayoutable!
    var l2: TestLayoutable!
    var l3: TestLayoutable!

    override func setUp() {
        super.setUp()
        l1 = TestLayoutable()
        l2 = TestLayoutable()
        l3 = TestLayoutable()
    }

    override func tearDown() {
        super.tearDown()
        l1 = nil
        l2 = nil
        l3 = nil
    }

    func testEmptyArray() {
        var layout = [TestLayoutable]()
            .equalSegments(orientation: .horizontal)
        layout.layoutWith(frame: CGRect())
        XCTAssert(true)
    }

    func testHorizontal() {
        var layout = [l1, l2, l3]
            .equalSegments(orientation: .horizontal)

        layout.layoutWith(
            frame: CGRect(
                x: 5,
                y: 5,
                width: 300,
                height: 100))

        XCTAssert(l1.frame.size.width == 100)
        XCTAssert(l2.frame.size.width == 100)
        XCTAssert(l3.frame.size.width == 100)
        XCTAssert(l1.frame.size.height == 100)
    }

    func testVertical() {
        var layout = [l1, l2, l3]
            .equalSegments(orientation: .vertical)

        layout.layoutWith(
            frame: CGRect(
                x: 5,
                y: 5,
                width: 100,
                height: 300))

        XCTAssert(l1.frame.size.height == 100)
        XCTAssert(l2.frame.size.height == 100)
        XCTAssert(l3.frame.size.height == 100)
        XCTAssert(l1.frame.size.width == 100)
    }

    func testGutterMarginsHorizontal() {
        l1.layoutMargins = UIEdgeInsets(
            top: 8,
            left: 7,
            bottom: 4,
            right: 3)
        var layout1 = [l1, l2, l3]
            .equalSegments(
            orientation: .horizontal,
            gutter: 10)

        layout1.layoutWith(
            frame: CGRect(
                x: 6,
                y: 6,
                width: 100 * 3 + 10 * 2,
                height: 100))

        XCTAssert(l1.frame.width == 100 - 7 - 3, "unexpected width: \(l1.frame.width)")
        XCTAssert(l1.frame.height == 100 - 8 - 4, "unexpected height")
        XCTAssert(l1.frame.origin.x == 6 + 7, "unexpected x")
        XCTAssert(l1.frame.origin.y == 6 + 8, "unexpected y")
    }
}
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
            .layoutEqualSegments(orientation: .horizontal)
        layout.startLayout(
            with: CGRect())
        XCTAssert(true) // Does not crash.
    }

    func testHorizontal() {
        var layout = [l1, l2, l3]
            .layoutEqualSegments(orientation: .horizontal)

        layout.startLayout(
            with: CGRect(
                x: 5,
                y: 5,
                width: 300,
                height: 100))

        XCTAssertEqual(l1.frame.size.width, 100)
        XCTAssertEqual(l2.frame.size.width, 100)
        XCTAssertEqual(l3.frame.size.width,100)
        XCTAssertEqual(l1.frame.size.height, 100)
    }

    func testVertical() {
        var layout = [l1, l2, l3]
            .layoutEqualSegments(orientation: .vertical)

        layout.startLayout(
            with: CGRect(
                x: 5,
                y: 5,
                width: 100,
                height: 300))

        XCTAssertEqual(l1.frame.size.height, 100)
        XCTAssertEqual(l2.frame.size.height, 100)
        XCTAssertEqual(l3.frame.size.height, 100)
        XCTAssertEqual(l1.frame.size.width, 100)
    }

    func testGutterMarginsHorizontal() {
        l1.layoutMargins = UIEdgeInsets(
            top: 8,
            left: 7,
            bottom: 4,
            right: 3)
        var layout1 = [l1, l2, l3]
            .layoutEqualSegments(
            orientation: .horizontal,
            gutter: 10)

        layout1.startLayout(
            with: CGRect(
                x: 6,
                y: 6,
                width: 100 * 3 + 10 * 2,
                height: 100))

        XCTAssertEqual(l1.frame.width, 100 - 7 - 3, "unexpected width")
        XCTAssertEqual(l1.frame.height, 100 - 8 - 4, "unexpected height")
        XCTAssertEqual(l1.frame.origin.x, 6 + 7, "unexpected x")
        XCTAssertEqual(l1.frame.origin.y, 6 + 8, "unexpected y")
        XCTAssertEqual(l2.frame.origin.x, 6 + 100 + 10, "unexpected l2 position")
    }

    func testGutterMarginsVertical() {
        l1.layoutMargins = UIEdgeInsets(
            top: 8,
            left: 7,
            bottom: 4,
            right: 3)
        var layout1 = [l1, l2, l3]
            .layoutEqualSegments(
            orientation: .vertical,
            gutter: 10)

        layout1.startLayout(
            with: CGRect(
                x: 6,
                y: 6,
                width: 100,
                height: 100 * 3 + 10 * 2))

        XCTAssertEqual(l1.frame.width, 100 - 7 - 3, "unexpected width")
        XCTAssertEqual(l1.frame.height, 100 - 8 - 4, "unexpected height")
        XCTAssertEqual(l1.frame.origin.x, 6 + 7, "unexpected x")
        XCTAssertEqual(l1.frame.origin.y, 6 + 8, "unexpected y")
        XCTAssertEqual(l2.frame.origin.y, 6 + 100 + 10, "unexpected l2 position")
    }

    func testMeasureHorizontal() {
        l1.m(5, 45, 2, 23)
        l2.m(1, 2, 3, 4)
        l3.m(5, 11, 2, 1)
        var layout = [l1, l2, l3].layoutEqualSegments(
            orientation: .horizontal,
            gutter: 10)

        let targetSize = CGSize(
            width: (TestLayoutable.sideLength + l1.horizontalMargins) * 3
                + 10 * 2,
            height: TestLayoutable.sideLength + l1.verticalMargins)  // largest vertical margins
        let size1 = layout.sizeThatFits(CGSize(width: 400, height: 300))
        let size2 = layout.sizeThatFits(CGSize(width: 200, height: 30))

        XCTAssertEqual(size1, targetSize,
            "bigger size does not match")
        XCTAssertEqual(size2, targetSize,
            "smaller size does not match")
    }

    func testMeasureVertical() {
        l1.m(5, 45, 2, 23)
        l2.m(1, 2, 3, 4)
        l3.m(5, 11, 2, 1)
        var layout = [l1, l2, l3].layoutEqualSegments(
            orientation: .vertical,
            gutter: 10)

        let targetSize = CGSize(
            width: TestLayoutable.sideLength + l1.horizontalMargins,
            height: (TestLayoutable.sideLength + l1.verticalMargins) * 3
                + 10 * 2)  // largest vertical margins
        let size1 = layout.sizeThatFits(CGSize(width: 400, height: 300))
        let size2 = layout.sizeThatFits(CGSize(width: 10, height: 30))

        XCTAssertEqual(size1, targetSize,
            "bigger size does not match")
        XCTAssertEqual(size2, targetSize,
            "smaller size does not match")
    }

    func testDifferentTypesPossible() {
        let anotherOne = AnotherOne()
        var layout = [l1, anotherOne].layoutEqualSegments(orientation: .horizontal)
        layout.startLayout(with: layoutRect)
        XCTAssert(true)
    }
}

private class AnotherOne: BayaLayoutable {
    var layoutMargins = UIEdgeInsets.zero
    var frame = CGRect()

    func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: 30, height: 30)
    }

    func layoutWith(frame: CGRect) {
        self.frame = frame
    }
}

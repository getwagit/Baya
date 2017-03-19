//
// Copyright (c) 2017 wag it GmbH.
// License: MIT
//

import Foundation

import XCTest
@testable import Baya

class BayaLinearTests: XCTestCase {
    var l1: TestLayoutable!
    var l2: TestLayoutable!
    var l3: TestLayoutable!
    let layoutRect = CGRect(
        x: 3,
        y: 3,
        width: 300,
        height: 300)

    override func setUp() {
        super.setUp()
        l1 = LinearTestLayoutable()
        l2 = LinearTestLayoutable()
        l3 = LinearTestLayoutable()

        l1.m(8, 7, 4, 40)
        l2.m(20, 13, 11, 4)
        l3.m(3, 15, 8, 1)
    }

    override func tearDown() {
        super.tearDown()
        l1 = nil
        l2 = nil
        l3 = nil
    }

    func testEmptyArray() {
        var layout = [TestLayoutable]()
            .layoutLinear(orientation: .horizontal)
        layout.layoutWith(frame: CGRect())
        XCTAssert(true) // Does not crash.
    }

    func testHorizontal() {
        var layout = [l1, l2, l3].layoutLinear(
            orientation: .horizontal,
            direction: .normal,
            spacing: 20)
        layout.layoutWith(frame: layoutRect)

        XCTAssertEqual(l1.frame, CGRect(
            x: 3 + l1.layoutMargins.left,
            y: 3 + l1.layoutMargins.top,
            width: 50,
            height: 300 - l1.verticalMargins),
            "l1 not matching")
        XCTAssertEqual(l2.frame, CGRect(
            x: 3 + LinearTestLayoutable.sideLength +
                l1.horizontalMargins + 20 + l2.layoutMargins.left,
            y: 3 + l2.layoutMargins.top,
            width: 50,
            height: 300 - l2.verticalMargins),
            "l2 not matching")
    }

    func testHorizontalReversed() {
        var layout = [l1, l2, l3].layoutLinear(
            orientation: .horizontal,
            direction: .reversed,
            spacing: 20)
        layout.layoutWith(frame: layoutRect)

        XCTAssertEqual(l3.frame, CGRect(
            x: 3 + 300
                - LinearTestLayoutable.sideLength * 3
                - l1.horizontalMargins
                - l2.horizontalMargins
                - l3.layoutMargins.right // left margin of l3 irrelevant for coordinate!
                - 20 * 2,
            y: 3 + l3.layoutMargins.top,
            width: 50,
            height: 300 - l3.verticalMargins),
            "l3 not matching")
    }

    func testVertical() {
        var layout = [l1, l2, l3].layoutLinear(
            orientation: .vertical,
            direction: .normal,
            spacing: 20)
        layout.layoutWith(frame: layoutRect)

        XCTAssertEqual(l3.frame, CGRect(
            x: 3 + l3.layoutMargins.left,
            y: 3 + LinearTestLayoutable.sideLength * 2
                + l1.verticalMargins + l2.verticalMargins
                + l3.layoutMargins.top
                + 20 * 2,
            width: 300 - l3.horizontalMargins,
            height: 50),
            "l3 not matching")
    }

    func testVerticalReversed() {
        var layout = [l1, l2, l3].layoutLinear(
            orientation: .vertical,
            direction: .reversed,
            spacing: 20)
        layout.layoutWith(frame: layoutRect)

        XCTAssertEqual(l3.frame, CGRect(
            x: 3 + l3.layoutMargins.left,
            y: 3 + 300
                - LinearTestLayoutable.sideLength * 3
                - l1.verticalMargins - l2.verticalMargins
                - l3.layoutMargins.bottom
                - 20 * 2,
            width: 300 - l3.horizontalMargins,
            height: 50),
            "l3 not matching")
    }

    func testMeasureHorizontal() {
        let layout = [l1, l2, l3].layoutLinear(
            orientation: .horizontal,
            direction: .normal,
            spacing: 20)
        let size = layout.sizeThatFits(layoutRect.size)
        let largestHeight = LinearTestLayoutable.sideLength + l2.verticalMargins // l2 has the biggest vertical margins.

        XCTAssertEqual(size, CGSize(
            width: LinearTestLayoutable.sideLength * 3
            + 20 * 2
            + l1.horizontalMargins + l2.horizontalMargins + l3.horizontalMargins,
            height: largestHeight),
            "size does not match")
    }

    func testMeasureVertical() {
        let layout = [l1, l2, l3].layoutLinear(
            orientation: .vertical,
            direction: .normal,
            spacing: 20)
        let size = layout.sizeThatFits(layoutRect.size)
        let largestWidth = LinearTestLayoutable.sideLength + l1.horizontalMargins // l1 has the biggest horizontal margins.

        XCTAssertEqual(size, CGSize(
            width: largestWidth,
            height: LinearTestLayoutable.sideLength * 3
                + 20 * 2
                + l1.verticalMargins + l2.verticalMargins + l3.verticalMargins),
            "size does not match")
    }
}

class LinearTestLayoutable: TestLayoutable {
    static let sideLength: CGFloat = 50

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(
            width: LinearTestLayoutable.sideLength,
            height: LinearTestLayoutable.sideLength)
    }
}

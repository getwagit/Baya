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
    let spacing: CGFloat = 20

    override func setUp() {
        super.setUp()
        l1 = TestLayoutable()
        l2 = TestLayoutable()
        l3 = TestLayoutable()

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
            .layoutLinearly(orientation: .horizontal)
        layout.startLayout(with: CGRect())
        XCTAssert(true) // Does not crash.
    }

    func testHorizontal() {
        var layout = [l1, l2, l3].layoutLinearly(
            orientation: .horizontal,
            direction: .normal,
            spacing: Int(spacing))
        layout.startLayout(
            with: layoutRect)

        XCTAssertEqual(l1.frame, CGRect(
            x: layoutRect.origin.x + l1.layoutMargins.left,
            y: layoutRect.origin.y + l1.layoutMargins.top,
            width: TestLayoutable.sideLength,
            height: TestLayoutable.sideLength),
            "l1 not matching")
        XCTAssertEqual(l2.frame, CGRect(
            x: layoutRect.origin.x
                + TestLayoutable.sideLength
                + l1.horizontalMargins
                + spacing
                + l2.layoutMargins.left,
            y: layoutRect.origin.y + l2.layoutMargins.top,
            width: TestLayoutable.sideLength,
            height: TestLayoutable.sideLength),
            "l2 not matching")
    }

    func testHorizontalReversed() {
        var layout = [l1, l2, l3].layoutLinearly(
            orientation: .horizontal,
            direction: .reversed,
            spacing: Int(spacing))
        layout.startLayout(
            with: layoutRect)
        let expectedFinalWidth = TestLayoutable.sideLength * 3
            + spacing * 2
            + l1.horizontalMargins
            + l2.horizontalMargins
            + l3.horizontalMargins;

        XCTAssertEqual(l1.frame, CGRect(
            x: layoutRect.origin.x
                + expectedFinalWidth
                - l1.layoutMargins.right
                - TestLayoutable.sideLength,
            y: layoutRect.origin.y + l1.layoutMargins.top,
            width: TestLayoutable.sideLength,
            height: TestLayoutable.sideLength),
                       "l1 not matching")
        XCTAssertEqual(l3.frame, CGRect(
            x: layoutRect.origin.x
                + expectedFinalWidth
                - TestLayoutable.sideLength * 3
                - l1.horizontalMargins
                - l2.horizontalMargins
                - l3.layoutMargins.right // left margin of l3 irrelevant for coordinate!
                - spacing * 2,
            y: layoutRect.origin.y + l3.layoutMargins.top,
            width: TestLayoutable.sideLength,
            height: TestLayoutable.sideLength),
            "l3 not matching")
    }

    func testVertical() {
        var layout = [l1, l2, l3].layoutLinearly(
            orientation: .vertical,
            direction: .normal,
            spacing: Int(spacing))
        layout.startLayout(
            with: layoutRect)

        XCTAssertEqual(l3.frame, CGRect(
            x: layoutRect.origin.x + l3.layoutMargins.left,
            y: layoutRect.origin.y
                + TestLayoutable.sideLength * 2
                + l1.verticalMargins + l2.verticalMargins
                + l3.layoutMargins.top
                + spacing * 2,
            width: TestLayoutable.sideLength,
            height: TestLayoutable.sideLength),
            "l3 not matching")
    }

    func testVerticalReversed() {
        var layout = [l1, l2, l3].layoutLinearly(
            orientation: .vertical,
            direction: .reversed,
            spacing: 20)
        layout.startLayout(
            with: layoutRect)
        let expectedFinalHeight = TestLayoutable.sideLength * 3
            + spacing * 2
            + l1.verticalMargins
            + l2.verticalMargins
            + l3.verticalMargins
        
        XCTAssertEqual(l1.frame, CGRect(
            x: layoutRect.origin.x + l1.layoutMargins.left,
            y: layoutRect.origin.y
                + expectedFinalHeight
                - TestLayoutable.sideLength
                - l1.layoutMargins.bottom,
            width: TestLayoutable.sideLength,
            height: TestLayoutable.sideLength),
            "l1 not matching")
        XCTAssertEqual(l3.frame, CGRect(
            x: layoutRect.origin.x + l3.layoutMargins.left,
            y: layoutRect.origin.y
                + expectedFinalHeight
                - TestLayoutable.sideLength * 3
                - l1.verticalMargins - l2.verticalMargins
                - l3.layoutMargins.bottom
                - spacing * 2,
            width: TestLayoutable.sideLength,
            height: TestLayoutable.sideLength),
            "l3 not matching")
    }

    func testMeasureHorizontal() {
        var layout = [l1, l2, l3].layoutLinearly(
            orientation: .horizontal,
            direction: .normal,
            spacing: Int(spacing))
        let size = layout.sizeThatFits(layoutRect.size)
        let largestHeight = TestLayoutable.sideLength + l2.verticalMargins // l2 has the biggest vertical margins.

        XCTAssertEqual(size, CGSize(
            width: TestLayoutable.sideLength * 3
            + spacing * 2
            + l1.horizontalMargins + l2.horizontalMargins + l3.horizontalMargins,
            height: largestHeight),
            "size does not match")
    }

    func testMeasureVertical() {
        var layout = [l1, l2, l3].layoutLinearly(
            orientation: .vertical,
            direction: .normal,
            spacing: Int(spacing))
        let size = layout.sizeThatFits(layoutRect.size)
        let largestWidth = TestLayoutable.sideLength + l1.horizontalMargins // l1 has the biggest horizontal margins.

        XCTAssertEqual(size, CGSize(
            width: largestWidth,
            height: TestLayoutable.sideLength * 3
                + spacing * 2
                + l1.verticalMargins + l2.verticalMargins + l3.verticalMargins),
            "size does not match")
    }
    
    func testDifferentTypesPossible() {
        let anotherOne = AnotherOne()
        var layout = [l1, anotherOne].layoutLinearly(orientation: .horizontal)
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


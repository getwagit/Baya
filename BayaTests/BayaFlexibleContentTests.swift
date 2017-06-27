//
// Copyright (c) 2017 wag it GmbH.
// License: MIT
//

import XCTest
@testable import Baya

class BayaFlexibleContentTests: XCTestCase {
    var l1: TestLayoutable!
    var l2: TestLayoutable!
    var l3: TestLayoutable!
    let layoutRect = CGRect(
        x: 6,
        y: 7,
        width: 500,
        height: 500)
    let layoutRectTooSmall = CGRect(
        x: 6,
        y: 7,
        width: 10,
        height: 10)
    let spacing: CGFloat = 10

    override func setUp() {
        super.setUp()
        l1 = TestLayoutable()
        l2 = TestLayoutable()
        l3 = TestLayoutable()

        l1.m(5, 45, 2, 23)
        l2.m(1, 2, 3, 4)
        l3.m(5, 11, 2, 1)
    }

    override func tearDown() {
        super.tearDown()
        l1 = nil
        l2 = nil
        l3 = nil
    }

    func testMeasureHorizontal() {
        var layout = l2.layoutFlexible(
            elementBefore: l1,
            elementAfter: l3,
            orientation: .horizontal,
            spacing: Int(spacing),
            layoutMargins: UIEdgeInsets.zero)
        let measuredSize = layout.sizeThatFitsWithMargins(layoutRect.size)

        let requiredWidth = TestLayoutable.sideLength * 3
            + l1.horizontalMargins
            + l2.horizontalMargins
            + l3.horizontalMargins
            + spacing * 2
        let requiredHeight = TestLayoutable.sideLength + max(l1.verticalMargins, l2.verticalMargins, l3.verticalMargins)

        XCTAssertEqual(measuredSize, CGSize(width: requiredWidth, height: requiredHeight))
    }

    func testMeasureVertical() {
        var layout = l2.layoutFlexible(
            elementBefore: l1,
            elementAfter: l3,
            orientation: .vertical,
            spacing: Int(spacing),
            layoutMargins: UIEdgeInsets.zero)
        let measuredSize = layout.sizeThatFitsWithMargins(layoutRect.size)

        let requiredHeight = TestLayoutable.sideLength * 3
            + l1.verticalMargins
            + l2.verticalMargins
            + l3.verticalMargins
            + spacing * 2
        let requiredWidth = TestLayoutable.sideLength + max(l1.horizontalMargins, l2.horizontalMargins, l3.horizontalMargins)

        XCTAssertEqual(measuredSize, CGSize(width: requiredWidth, height: requiredHeight))
    }

    func testHorizontal() {
        var layout = l2.layoutFlexible(
            elementBefore: l1,
            elementAfter: l3,
            orientation: .horizontal,
            spacing: Int(spacing),
            layoutMargins: UIEdgeInsets.zero)
        layout.startLayout(with: layoutRect)

        let requiredWidth = TestLayoutable.sideLength * 3
            + l1.horizontalMargins
            + l2.horizontalMargins
            + l3.horizontalMargins
            + spacing * 2

        XCTAssertEqual(l1.frame, CGRect(
            x: layoutRect.minX + l1.layoutMargins.left,
            y: layoutRect.minY + l1.layoutMargins.top,
            width: TestLayoutable.sideLength,
            height: TestLayoutable.sideLength))
        XCTAssertEqual(l3.frame, CGRect(
            x: layoutRect.minX + requiredWidth - TestLayoutable.sideLength - l3.layoutMargins.right,
            y: layoutRect.minY + l3.layoutMargins.top,
            width: TestLayoutable.sideLength,
            height: TestLayoutable.sideLength))
        XCTAssertEqual(l2.frame, CGRect(
            x: layoutRect.minX + TestLayoutable.sideLength + l1.horizontalMargins + spacing + l2.layoutMargins.left,
            y: layoutRect.minY + l2.layoutMargins.top,
            width: TestLayoutable.sideLength,
            height: TestLayoutable.sideLength))
    }

    func testVertical() {
        var layout = l2.layoutFlexible(
            elementBefore: l1,
            elementAfter: l3,
            orientation: .vertical,
            spacing: Int(spacing),
            layoutMargins: UIEdgeInsets.zero)
        layout.startLayout(with: layoutRect)

        let requiredHeight = TestLayoutable.sideLength * 3
            + l1.verticalMargins
            + l2.verticalMargins
            + l3.verticalMargins
            + spacing * 2

        XCTAssertEqual(l1.frame, CGRect(
            x: layoutRect.minX + l1.layoutMargins.left,
            y: layoutRect.minY + l1.layoutMargins.top,
            width: TestLayoutable.sideLength,
            height: TestLayoutable.sideLength))
        XCTAssertEqual(l3.frame, CGRect(
            x: layoutRect.minX + l3.layoutMargins.left,
            y: layoutRect.minY + requiredHeight - TestLayoutable.sideLength - l3.layoutMargins.bottom,
            width: TestLayoutable.sideLength,
            height: TestLayoutable.sideLength))
        XCTAssertEqual(l2.frame, CGRect(
            x: layoutRect.minX + l2.layoutMargins.left,
            y: layoutRect.minY + TestLayoutable.sideLength + l1.verticalMargins + spacing + l2.layoutMargins.top,
            width: TestLayoutable.sideLength,
            height: TestLayoutable.sideLength))
    }

    func testHorizontalWithNoOptionalElements() {
        var layout = l2.layoutFlexible(
            elementBefore: nil,
            elementAfter: nil,
            orientation: .horizontal,
            spacing: Int(spacing),
            layoutMargins: UIEdgeInsets.zero)
        layout.startLayout(with: layoutRect)

        XCTAssertEqual(l2.frame, CGRect(
            x: layoutRect.minX + l2.layoutMargins.left,
            y: layoutRect.minY + l2.layoutMargins.top,
            width: TestLayoutable.sideLength,
            height: TestLayoutable.sideLength))
    }

    func testVerticalWithNoOptionalElements() {
        var layout = l2.layoutFlexible(
            elementBefore: nil,
            elementAfter: nil,
            orientation: .vertical,
            spacing: Int(spacing),
            layoutMargins: UIEdgeInsets.zero)
        layout.startLayout(with: layoutRect)

        XCTAssertEqual(l2.frame, CGRect(
            x: layoutRect.minX + l2.layoutMargins.left,
            y: layoutRect.minY + l2.layoutMargins.top,
            width: TestLayoutable.sideLength,
            height: TestLayoutable.sideLength))
    }

    func testHorizontalFillsSizeIfRequested() {
        l2 = TakesWhatItGets()
        l2.m(1, 2, 3, 4)

        var layout = l2.layoutFlexible(
            elementBefore: l1,
            elementAfter: l3,
            orientation: .horizontal,
            spacing: Int(spacing),
            layoutMargins: UIEdgeInsets.zero)
        layout.startLayout(with: layoutRect)

        XCTAssertEqual(l1.frame, CGRect(
            x: layoutRect.minX + l1.layoutMargins.left,
            y: layoutRect.minY + l1.layoutMargins.top,
            width: TestLayoutable.sideLength,
            height: TestLayoutable.sideLength))
        XCTAssertEqual(l3.frame, CGRect(
            x: layoutRect.maxX - TestLayoutable.sideLength - l3.layoutMargins.right,
            y: layoutRect.minY + l3.layoutMargins.top,
            width: TestLayoutable.sideLength,
            height: TestLayoutable.sideLength))
        XCTAssertEqual(l2.frame, CGRect(
            x: layoutRect.minX + TestLayoutable.sideLength + l1.horizontalMargins + spacing + l2.layoutMargins.left,
            y: layoutRect.minY + l2.layoutMargins.top,
            width: layoutRect.width - TestLayoutable.sideLength * 2 - spacing * 2 - l1.horizontalMargins - l3.horizontalMargins - l2.horizontalMargins,
            height: layoutRect.height - l2.verticalMargins))
    }

    func testVerticalFillsSizeIfRequested() {
        l2 = TakesWhatItGets()
        l2.m(1, 2, 3, 4)

        var layout = l2.layoutFlexible(
            elementBefore: l1,
            elementAfter: l3,
            orientation: .vertical,
            spacing: Int(spacing),
            layoutMargins: UIEdgeInsets.zero)
        layout.startLayout(with: layoutRect)

        XCTAssertEqual(l1.frame, CGRect(
            x: layoutRect.minX + l1.layoutMargins.left,
            y: layoutRect.minY + l1.layoutMargins.top,
            width: TestLayoutable.sideLength,
            height: TestLayoutable.sideLength))
        XCTAssertEqual(l3.frame, CGRect(
            x: layoutRect.minX + l3.layoutMargins.left,
            y: layoutRect.maxY - TestLayoutable.sideLength - l3.layoutMargins.bottom,
            width: TestLayoutable.sideLength,
            height: TestLayoutable.sideLength))
        XCTAssertEqual(l2.frame, CGRect(
            x: layoutRect.minX + l2.layoutMargins.left,
            y: layoutRect.minY + TestLayoutable.sideLength + l1.verticalMargins + spacing + l2.layoutMargins.top,
            width: layoutRect.width - l2.horizontalMargins,
            height: layoutRect.height - TestLayoutable.sideLength * 2 - spacing * 2 - l1.verticalMargins - l2.verticalMargins - l3.verticalMargins))
    }
}

private class TakesWhatItGets: TestLayoutable {
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return size
    }
}

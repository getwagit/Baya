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
        l1 = TestLayoutable(sideLength: 40)
        l2 = TestLayoutable(sideLength: 60)
        l3 = TestLayoutable(sideLength: 100)

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

        let requiredWidth = l1.sideLength
            + l2.sideLength
            + l3.sideLength
            + l1.horizontalMargins
            + l2.horizontalMargins
            + l3.horizontalMargins
            + spacing * 2
        let requiredHeight = max(l1.sideLength + l1.verticalMargins, l2.sideLength + l2.verticalMargins, l3.sideLength + l3.verticalMargins)
        
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

        let requiredHeight = l1.sideLength
            + l2.sideLength
            + l3.sideLength
            + l1.verticalMargins
            + l2.verticalMargins
            + l3.verticalMargins
            + spacing * 2
        let requiredWidth = max(l1.sideLength + l1.horizontalMargins, l2.sideLength + l2.horizontalMargins, l3.sideLength + l3.horizontalMargins)

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

        let requiredWidth = l1.sideLength
            + l2.sideLength
            + l3.sideLength
            + l1.horizontalMargins
            + l2.horizontalMargins
            + l3.horizontalMargins
            + spacing * 2

        XCTAssertEqual(
            l1.frame,
            CGRect(
                x: layoutRect.minX + l1.layoutMargins.left,
                y: layoutRect.minY + l1.layoutMargins.top,
                width: l1.sideLength,
                height: l1.sideLength))
        XCTAssertEqual(
            l3.frame,
            CGRect(
                x: layoutRect.minX + requiredWidth - l3.sideLength - l3.layoutMargins.right,
                y: layoutRect.minY + l3.layoutMargins.top,
                width: l3.sideLength,
                height: l3.sideLength))
        XCTAssertEqual(
            l2.frame,
            CGRect(
                x: layoutRect.minX + l1.sideLength + l1.horizontalMargins + spacing + l2.layoutMargins.left,
                y: layoutRect.minY + l2.layoutMargins.top,
                width: l2.sideLength,
                height: l2.sideLength))
    }

    func testVertical() {
        var layout = l2.layoutFlexible(
            elementBefore: l1,
            elementAfter: l3,
            orientation: .vertical,
            spacing: Int(spacing),
            layoutMargins: UIEdgeInsets.zero)
        layout.startLayout(with: layoutRect)

        let requiredHeight = l1.sideLength
            + l2.sideLength
            + l3.sideLength
            + l1.verticalMargins
            + l2.verticalMargins
            + l3.verticalMargins
            + spacing * 2

        XCTAssertEqual(
            l1.frame,
            CGRect(
                x: layoutRect.minX + l1.layoutMargins.left,
                y: layoutRect.minY + l1.layoutMargins.top,
                width: l1.sideLength,
                height: l1.sideLength))
        XCTAssertEqual(
            l3.frame,
            CGRect(
                x: layoutRect.minX + l3.layoutMargins.left,
                y: layoutRect.minY + requiredHeight - l3.sideLength - l3.layoutMargins.bottom,
                width: l3.sideLength,
                height: l3.sideLength))
        XCTAssertEqual(
            l2.frame,
            CGRect(
                x: layoutRect.minX + l2.layoutMargins.left,
                y: layoutRect.minY + l1.sideLength + l1.verticalMargins + spacing + l2.layoutMargins.top,
                width: l2.sideLength,
                height: l2.sideLength))
    }

    func testHorizontalWithNoOptionalElements() {
        var layout = l2.layoutFlexible(
            elementBefore: nil,
            elementAfter: nil,
            orientation: .horizontal,
            spacing: Int(spacing),
            layoutMargins: UIEdgeInsets.zero)
        layout.startLayout(with: layoutRect)

        XCTAssertEqual(
            l2.frame,
            CGRect(
                x: layoutRect.minX + l2.layoutMargins.left,
                y: layoutRect.minY + l2.layoutMargins.top,
                width: l2.sideLength,
                height: l2.sideLength))
    }

    func testVerticalWithNoOptionalElements() {
        var layout = l2.layoutFlexible(
            elementBefore: nil,
            elementAfter: nil,
            orientation: .vertical,
            spacing: Int(spacing),
            layoutMargins: UIEdgeInsets.zero)
        layout.startLayout(with: layoutRect)

        XCTAssertEqual(
            l2.frame,
            CGRect(
                x: layoutRect.minX + l2.layoutMargins.left,
                y: layoutRect.minY + l2.layoutMargins.top,
                width: l2.sideLength,
                height: l2.sideLength))
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

        XCTAssertEqual(
            l1.frame,
            CGRect(
                x: layoutRect.minX + l1.layoutMargins.left,
                y: layoutRect.minY + l1.layoutMargins.top,
                width: l1.sideLength,
                height: l1.sideLength))
        XCTAssertEqual(
            l3.frame,
            CGRect(
                x: layoutRect.maxX - l3.sideLength - l3.layoutMargins.right,
                y: layoutRect.minY + l3.layoutMargins.top,
                width: l3.sideLength,
                height: l3.sideLength))
        XCTAssertEqual(
            l2.frame,
            CGRect(
                x: layoutRect.minX + l1.sideLength + l1.horizontalMargins + spacing + l2.layoutMargins.left,
                y: layoutRect.minY + l2.layoutMargins.top,
                width: layoutRect.width - l1.sideLength - l3.sideLength - spacing * 2 - l1.horizontalMargins - l3.horizontalMargins - l2.horizontalMargins,
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

        XCTAssertEqual(
            l1.frame,
            CGRect(
                x: layoutRect.minX + l1.layoutMargins.left,
                y: layoutRect.minY + l1.layoutMargins.top,
                width: l1.sideLength,
                height: l1.sideLength))
        XCTAssertEqual(
            l3.frame,
            CGRect(
                x: layoutRect.minX + l3.layoutMargins.left,
                y: layoutRect.maxY - l3.sideLength - l3.layoutMargins.bottom,
                width: l3.sideLength,
                height: l3.sideLength))
        XCTAssertEqual(
            l2.frame,
            CGRect(
                x: layoutRect.minX + l2.layoutMargins.left,
                y: layoutRect.minY + l1.sideLength + l1.verticalMargins + spacing + l2.layoutMargins.top,
                width: layoutRect.width - l2.horizontalMargins,
                height: layoutRect.height - l1.sideLength - l3.sideLength - spacing * 2 - l1.verticalMargins - l2.verticalMargins - l3.verticalMargins))
    }
}

private class TakesWhatItGets: TestLayoutable {
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return size
    }
}

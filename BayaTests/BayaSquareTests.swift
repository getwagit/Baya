//
// Copyright (c) 2017 wag it GmbH.
// License: MIT
//

import Foundation
import XCTest
@testable import Baya

class BayaSquareTests: XCTestCase {
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

    func testMeasureSquareFromWidth() {
        var layout = l.layoutAsSquare(referenceSide: .horizontal)
        let measure = layout.sizeThatFits(layoutRect.size)

        XCTAssertEqual(
            measure,
            CGSize(
                width: layoutRect.size.width,
                height: layoutRect.size.width),
            "size does not match")
    }

    func testMeasureSquareFromHeight() {
        var layout = l.layoutAsSquare(referenceSide: .vertical)
        let measure = layout.sizeThatFits(layoutRect.size)

        XCTAssertEqual(
            measure,
            CGSize(
                width: layoutRect.size.height,
                height: layoutRect.size.height),
            "size does not match")
    }

    func testMeasureSquareFromSmallerSide() {
        var layout = l.layoutAsSquare()
        let measure = layout.sizeThatFits(layoutRect.size)

        XCTAssertEqual(
            measure,
            CGSize(
                width: layoutRect.size.width,
                height: layoutRect.size.width),
            "size does not match")
    }

    func testLayoutSquareFromWidth() {
        var layout = l.layoutAsSquare(referenceSide: .horizontal)
        layout.startLayout(with: layoutRect)
        XCTAssertEqual(
            l.frame,
            CGRect(
                x: layoutRect.minX + l.layoutMargins.left,
                y: layoutRect.minY + l.layoutMargins.top,
                width: 300 - l.horizontalMargins,
                height: 300 - l.horizontalMargins),
            "frame does not match")
    }

    func testLayoutSquareFromHeight() {
        var layout = l.layoutAsSquare(referenceSide: .vertical)
        layout.startLayout(with: layoutRect)
        XCTAssertEqual(
            l.frame,
            CGRect(
                x: layoutRect.minX + l.layoutMargins.left,
                y: layoutRect.minY + l.layoutMargins.top,
                width: 400 - l.verticalMargins,
                height: 400 - l.verticalMargins),
            "frame does not match")
    }

    func testLayoutSquareFromSmallerSide() {
        var layout = l.layoutAsSquare()
        layout.startLayout(with: layoutRect)
        XCTAssertEqual(
            l.frame,
            CGRect(
                x: layoutRect.minX + l.layoutMargins.left,
                y: layoutRect.minY + l.layoutMargins.top,
                width: 300 - l.horizontalMargins,
                height: 300 - l.horizontalMargins),
            "frame does not match")
    }

    func testLayoutModesAreOverridden() {
        l = TestLayoutable(sideLength: 50, layoutModes: BayaLayoutOptions.Modes(width: .matchParent, height: .matchParent))
        var layout = l.layoutAsSquare()
        layout.startLayout(with: layoutRect)
        // Would have a larger height if layout modes would be overridden.
        XCTAssertEqual(
            l.frame,
            CGRect(
                x: layoutRect.minX + l.layoutMargins.left,
                y: layoutRect.minY + l.layoutMargins.top,
                width: 300 - l.horizontalMargins,
                height: 300 - l.horizontalMargins),
            "frame does not match when using matchParent")
        // Wrap content should not make any difference
        let l2 = TestLayoutable(sideLength: 50, layoutModes: BayaLayoutOptions.Modes(width: .wrapContent, height: .wrapContent))
        var layout2 = l2.layoutAsSquare()
        layout2.startLayout(with: layoutRect)
        XCTAssertEqual(
            l.frame,
            l2.frame,
            "Frames using matchParent and wrapContent are different but should be the same")

    }
}
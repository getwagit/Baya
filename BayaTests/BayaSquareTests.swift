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
        l = TestLayoutable(width: 60, height: 90)
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

    func testMeasureSquare() {
        var layout = l.layoutAsSquare()
        let measure = layout.sizeThatFits(layoutRect.size)
        let bigSide = max(l.width, l.height)
        
        XCTAssertEqual(
            measure,
            CGSize(
                width: bigSide,
                height: bigSide),
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
                width: layoutRect.width - l.horizontalMargins,
                height: layoutRect.width - l.horizontalMargins),
            "frame does not match")
    }
    
    func testLayoutSquareFromWidthSmallFrame() {
        l = TestLayoutable(width: 80, height: 90)
        l.m(2, 4, 1, 2)
        var layout = l.layoutAsSquare(referenceSide: .horizontal)
        let smallLayoutRect = CGRect(x: 1, y: 2, width: 40, height: 30)
        layout.startLayout(with: smallLayoutRect)
        
        XCTAssertEqual(
            l.frame,
            CGRect(
                x: smallLayoutRect.minX + l.layoutMargins.left,
                y: smallLayoutRect.minY + l.layoutMargins.top,
                width: smallLayoutRect.width - l.horizontalMargins,
                height: smallLayoutRect.width - l.horizontalMargins),
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
                width: layoutRect.height - l.verticalMargins,
                height: layoutRect.height - l.verticalMargins),
            "frame does not match")
    }
    
    func testLayoutSquareFromHeightSmallFrame() {
        l = TestLayoutable(width: 80, height: 90)
        l.m(2, 4, 1, 2)
        var layout = l.layoutAsSquare(referenceSide: .vertical)
        let smallLayoutRect = CGRect(x: 1, y: 2, width: 40, height: 30)
        layout.startLayout(with: smallLayoutRect)
        
        XCTAssertEqual(
            l.frame,
            CGRect(
                x: smallLayoutRect.minX + l.layoutMargins.left,
                y: smallLayoutRect.minY + l.layoutMargins.top,
                width: smallLayoutRect.height - l.verticalMargins,
                height: smallLayoutRect.height - l.verticalMargins),
            "frame does not match")
    }

    func testLayoutSquare() {
        var layout = l.layoutAsSquare()
        layout.startLayout(with: layoutRect)
        let bigSide = max(l.width, l.height)

        XCTAssertEqual(
            l.frame,
            CGRect(
                x: layoutRect.minX + l.layoutMargins.left,
                y: layoutRect.minY + l.layoutMargins.top,
                width: bigSide,
                height: bigSide),
            "frame does not match")
    }

    func testLayoutModesAreOverridden() {
        l = TestLayoutable(
            width: 60,
            height: 20,
            layoutModes: BayaLayoutOptions.Modes(
                width: .matchParent,
                height: .matchParent))
        var layout = l.layoutAsSquare()
        layout.startLayout(with: layoutRect)
        let bigSide = max(l.width, l.height)

        XCTAssertEqual(
            l.frame,
            CGRect(
                x: layoutRect.minX + l.layoutMargins.left,
                y: layoutRect.minY + l.layoutMargins.top,
                width: bigSide,
                height: bigSide),
            "frame does not match when using matchParent")
        
        // Wrap content should not make any difference
        let l2 = TestLayoutable(
            width: 70,
            height: 10,
            layoutModes: BayaLayoutOptions.Modes(
                width: .wrapContent,
                height: .wrapContent))
        var layout2 = l2.layoutAsSquare()
        layout2.startLayout(with: layoutRect)
        let bigSide2 = max(l2.width, l2.height)

        XCTAssertEqual(
            l2.frame,
            CGRect(
                x: layoutRect.minX + l.layoutMargins.left,
                y: layoutRect.minY + l.layoutMargins.top,
                width: bigSide2,
                height: bigSide2),
            "Frames using matchParent and wrapContent are different but should be the same")
    }
}

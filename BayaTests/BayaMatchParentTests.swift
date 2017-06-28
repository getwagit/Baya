//
// Copyright (c) 2017 wag it GmbH.
// License: MIT
//

import Foundation

import XCTest
@testable import Baya

class BayaMatchParentTests: XCTestCase {
    var l: TestLayoutable!
    var layoutRect = CGRect(x: 3, y: 3, width: 300, height: 400)

    override func setUp() {
        super.setUp()
        l = TestLayoutable()
        l.m(1, 2, 3, 4)
    }

    override func tearDown() {
        super.tearDown()
        l = nil
    }

    func testMatchParent() {
        var layout = l.layoutMatchingParent(width: true, height: true)
        layout.startLayout(with: layoutRect)

        XCTAssertEqual(
            l.frame,
            CGRect(
                x: layoutRect.minX + l.layoutMargins.left,
                y: layoutRect.minY + l.layoutMargins.top,
                width: layoutRect.width - l.horizontalMargins,
                height: layoutRect.height - l.verticalMargins),
            "frame not matching")
    }

    func testMatchParentWidth() {
        var layout = l.layoutMatchingParent(width: true, height: false)
        layout.startLayout(with: layoutRect)

        XCTAssertEqual(
            l.frame,
            CGRect(
                x: layoutRect.minX + l.layoutMargins.left,
                y: layoutRect.minY + l.layoutMargins.top,
                width: layoutRect.width - l.horizontalMargins,
                height: l.sideLength),
            "frame not matching")
    }

    func testMatchParentHeight() {
        var layout = l.layoutMatchingParent(width: false, height: true)
        layout.startLayout(with: layoutRect)
        
        XCTAssertEqual(
            l.frame,
            CGRect(
                x: layoutRect.minX + l.layoutMargins.left,
                y: layoutRect.minY + l.layoutMargins.top,
                width: l.sideLength,
                height: layoutRect.height - l.verticalMargins),
            "frame not matching")
    }

    func testMeasureMatchParent() {
        var layout = l.layoutMatchingParent(width: true, height: true)
        let fit = layout.sizeThatFits(layoutRect.size)
        
        XCTAssertEqual(
            fit,
            layoutRect.size,
            "size not matching")
    }

    func testMeasureMatchParentWidth() {
        var layout = l.layoutMatchingParent(width: true, height: false)
        let fit = layout.sizeThatFits(layoutRect.size)
        
        XCTAssertEqual(
            fit,
            CGSize(
                width: layoutRect.width,
                height: l.sideLength + l.verticalMargins),
            "size not matching")
    }

    func testMeasureMatchParentHeight() {
        var layout = l.layoutMatchingParent(width: false, height: true)
        let fit = layout.sizeThatFits(layoutRect.size)
        
        XCTAssertEqual(
            fit,
            CGSize(
                width: l.sideLength + l.horizontalMargins,
                height: layoutRect.height),
            "size not matching")
    }
}

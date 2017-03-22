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
        var layout = l.layoutMatchParent(width: true, height: true)
        layout.startLayout(with: layoutRect)

        XCTAssertEqual(
            l.frame,
            CGRect(
                x: layoutRect.minX + l.layoutMargins.left,
                y: layoutRect.minY + l.layoutMargins.top,
                width: layoutRect.width - l.layoutMargins.left - l.layoutMargins.right,
                height: layoutRect.height - l.layoutMargins.top - l.layoutMargins.bottom),
            "frame not matching")
    }

    func testMatchParentWidth() {
        var layout = l.layoutMatchParent(width: true, height: false)
        layout.startLayout(with: layoutRect)

        XCTAssertEqual(
            l.frame,
            CGRect(
                x: layoutRect.minX + l.layoutMargins.left,
                y: layoutRect.minY + l.layoutMargins.top,
                width: layoutRect.width - l.layoutMargins.left - l.layoutMargins.right,
                height: TestLayoutable.sideLength),
            "frame not matching")
    }

    func testMatchParentHeight() {
        var layout = l.layoutMatchParent(width: false, height: true)
        layout.startLayout(with: layoutRect)
        
        XCTAssertEqual(
            l.frame,
            CGRect(
                x: layoutRect.minX + l.layoutMargins.left,
                y: layoutRect.minY + l.layoutMargins.top,
                width: TestLayoutable.sideLength,
                height: layoutRect.height - l.layoutMargins.top - l.layoutMargins.bottom),
            "frame not matching")
    }

    func testMeasureMatchParent() {
        let layout = l.layoutMatchParent(width: true, height: true)
        let fit = layout.sizeThatFits(layoutRect.size)
        
        XCTAssertEqual(
            fit,
            layoutRect.size,
            "size not matching")
    }

    func testMeasureMatchParentWidth() {
        let layout = l.layoutMatchParent(width: true, height: false)
        let fit = layout.sizeThatFits(layoutRect.size)
        
        XCTAssertEqual(
            fit,
            CGSize(
                width: layoutRect.width,
                height: TestLayoutable.sideLength + l.verticalMargins),
            "size not matching")
    }

    func testMeasureMatchParentHeight() {
        let layout = l.layoutMatchParent(width: false, height: true)
        let fit = layout.sizeThatFits(layoutRect.size)
        
        XCTAssertEqual(
            fit,
            CGSize(
                width: TestLayoutable.sideLength + l.horizontalMargins,
                height: layoutRect.height),
            "size not matching")
    }
}

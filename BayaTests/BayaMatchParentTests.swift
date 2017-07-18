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
        var layout = l.layoutMatchingParent()
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
        var layout = l.layoutMatchingParentWidth()
        layout.startLayout(with: layoutRect)

        XCTAssertEqual(
            l.frame,
            CGRect(
                x: layoutRect.minX + l.layoutMargins.left,
                y: layoutRect.minY + l.layoutMargins.top,
                width: layoutRect.width - l.horizontalMargins,
                height: l.height),
            "frame not matching")
    }

    func testMatchParentHeight() {
        var layout = l.layoutMatchingParentHeight()
        layout.startLayout(with: layoutRect)
        
        XCTAssertEqual(
            l.frame,
            CGRect(
                x: layoutRect.minX + l.layoutMargins.left,
                y: layoutRect.minY + l.layoutMargins.top,
                width: l.width,
                height: layoutRect.height - l.verticalMargins),
            "frame not matching")
    }

    func testMeasureNotAffectedByMatchParent() {
        var layout = l.layoutMatchingParent()
        let fit = layout.sizeThatFits(layoutRect.size)

        XCTAssertEqual(
            fit,
            CGSize(width: l.width, height: l.height),
            "size not matching")
    }
}

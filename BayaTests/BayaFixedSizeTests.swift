//
// Copyright (c) 2016-2017 wag it GmbH.
// License: MIT
//

import Foundation

import XCTest
@testable import Baya

class BayaFixedSizeTests: XCTestCase {
    var l: TestLayoutable!
    let layoutRect = CGRect(
        x: 3,
        y: 3,
        width: 300,
        height: 300)

    override func setUp() {
        super.setUp()
        l = TestLayoutable()
        l.m(1, 2, 3, 4)
    }

    override func tearDown() {
        super.tearDown()
        l = nil
    }

    func testFixedHeight() {
        let fixedHeight: CGFloat = 100
        var layout = l.layoutWithFixedSize(width: nil, height: fixedHeight)
        layout.startLayout(with: layoutRect)

        XCTAssertEqual(
            l.frame,
            CGRect(
                x: layoutRect.minX + l.layoutMargins.left,
                y: layoutRect.minY + l.layoutMargins.top,
                width: l.width,
                height: fixedHeight - l.verticalMargins),
            "frame not matching")
    }
    
    func testFixedHeightMatchingWidth() {
        let fixedHeight: CGFloat = 100
        l = TestLayoutable(layoutModes: BayaLayoutOptions.Modes(width: .matchParent, height: .wrapContent))
        var layout = l.layoutWithFixedSize(width: nil, height: fixedHeight)
        layout.startLayout(with: layoutRect)
        
        XCTAssertEqual(
            l.frame,
            CGRect(
                x: layoutRect.minX + l.layoutMargins.left,
                y: layoutRect.minY + l.layoutMargins.top,
                width: layoutRect.width - l.horizontalMargins,
                height: fixedHeight - l.verticalMargins),
            "frame not matching")
    }

    func testFixedWidth() {
        let fixedWidth: CGFloat = 75
        var layout = l.layoutWithFixedSize(width: fixedWidth, height: nil)
        layout.startLayout(with: layoutRect)

        XCTAssertEqual(
            l.frame,
            CGRect(
                x: layoutRect.minX + l.layoutMargins.left,
                y: layoutRect.minY + l.layoutMargins.top,
                width: fixedWidth - l.horizontalMargins,
                height: l.height),
            "frame not matching")
    }
    
    func testFixedWidthMatchingHeight() {
        let fixedWidth: CGFloat = 100
        l = TestLayoutable(layoutModes: BayaLayoutOptions.Modes(width: .wrapContent, height: .matchParent))
        var layout = l.layoutWithFixedSize(width: fixedWidth, height: nil)
        layout.startLayout(with: layoutRect)
        
        XCTAssertEqual(
            l.frame,
            CGRect(
                x: layoutRect.minX + l.layoutMargins.left,
                y: layoutRect.minY + l.layoutMargins.top,
                width: fixedWidth - l.horizontalMargins,
                height: layoutRect.height - l.verticalMargins),
            "frame not matching")
    }

    func testFixedSize() {
        let fixedSize: CGSize = CGSize(width: 55, height: 99)
        var layout = l.layoutWithFixedSize(width: fixedSize.width, height: fixedSize.height)
        layout.startLayout(with: layoutRect)

        XCTAssertEqual(
            l.frame,
            CGRect(
                x: layoutRect.minX + l.layoutMargins.left,
                y: layoutRect.minY + l.layoutMargins.top,
                width: fixedSize.width - l.horizontalMargins,
                height: fixedSize.height - l.verticalMargins),
            "frame not matching")
    }

    func testMeasureFixedSize() {
        let fixedSize: CGSize = CGSize(width: 40, height: 70)
        var layout = l.layoutWithFixedSize(width: fixedSize.width, height: fixedSize.height)
        let fit = layout.sizeThatFits(layoutRect.size)

        XCTAssertEqual(
            fit,
            fixedSize,
            "size not matching")
    }
    
    func testMeasureFixedHeight() {
        let fixedHeight: CGFloat = 60
        var layout = l.layoutWithFixedSize(width: nil, height: fixedHeight)
        let fit = layout.sizeThatFits(layoutRect.size)

        XCTAssertEqual(
            fit,
            CGSize(
                width: l.horizontalMargins + l.width,
                height: fixedHeight),
            "size not matching")
    }

    func testMeasureFixedWidth() {
        let fixedWidth: CGFloat = 34
        var layout = l.layoutWithFixedSize(width: fixedWidth, height: nil)
        let fit = layout.sizeThatFits(layoutRect.size)

        XCTAssertEqual(
            fit,
            CGSize(
                width: fixedWidth,
                height: l.verticalMargins + l.height),
            "size not matching")
    }
}

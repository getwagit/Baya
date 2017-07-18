//
// Copyright (c) 2017 wag it GmbH.
// License: MIT
//

import Foundation

import XCTest
@testable import Baya

class BayaFrameTests: XCTestCase {
    var l1: TestLayoutable!
    var l2: TestLayoutable!
    var l3: TestLayoutable!

    override func setUp() {
        super.setUp()
        l1 = TestLayoutable(sideLength: 30)
        l2 = TestLayoutable(sideLength: 60)
        l3 = TestLayoutable(sideLength: 90)

        l1.layoutMargins = UIEdgeInsets(
            top: 8,
            left: 7,
            bottom: 4,
            right: 3)
        l2.layoutMargins = UIEdgeInsets(
            top: 20,
            left: 50,
            bottom: 23,
            right: 12)
        l3.layoutMargins = UIEdgeInsets.zero
    }

    override func tearDown() {
        super.tearDown()
        l1 = nil
        l2 = nil
        l3 = nil
    }

    func testEmptyArray() {
        var layout = [TestLayoutable]().layoutAsFrame()
        layout.startLayout(
            with: CGRect())
        XCTAssert(true) // Does not crash.
    }

    func testSizesWrappingContent() {
        var layout = [l1, l2, l3]
            .layoutAsFrame()
        let layoutRect = CGRect(
            x: 5,
            y: 10,
            width: 300,
            height: 300)
        layout.startLayout(with: layoutRect)

        XCTAssertEqual(
            l2.frame,
            CGRect(
                x: layoutRect.origin.x
                    + l2.layoutMargins.left,
                y: layoutRect.origin.y
                    + l2.layoutMargins.top,
                width: l2.width,
                height: l2.height))
        XCTAssertEqual(
            l1.frame,
            CGRect(
                x: layoutRect.origin.x
                    + l1.layoutMargins.left,
                y: layoutRect.origin.y
                    + l1.layoutMargins.top,
                width: l1.width,
                height: l1.height))
        XCTAssertEqual(
            l3.frame,
            CGRect(
                x: layoutRect.origin.x
                    + l3.layoutMargins.left,
                y: layoutRect.origin.y
                    + l3.layoutMargins.top,
                width: l3.width,
                height: l3.height))
    }

    func testSizesMatchingParent() {
        l1 = TestLayoutable(sideLength: 30, layoutModes: BayaLayoutOptions.Modes(width: .matchParent, height: .matchParent))
        l2 = TestLayoutable(sideLength: 60, layoutModes: BayaLayoutOptions.Modes(width: .matchParent, height: .matchParent))
        l3 = TestLayoutable(sideLength: 90, layoutModes: BayaLayoutOptions.Modes(width: .matchParent, height: .matchParent))
        var layout = [l1, l2, l3]
            .layoutAsFrame()
        let layoutRect = CGRect(
            x: 5,
            y: 10,
            width: 300,
            height: 300)
        layout.startLayout(with: layoutRect)
        
        let maxWidth = max(
            l1.width + l1.horizontalMargins,
            l2.width + l2.horizontalMargins,
            l3.width + l3.horizontalMargins)
        let maxHeight = max(
            l1.height + l1.verticalMargins,
            l2.height + l2.verticalMargins,
            l3.height + l3.verticalMargins)

        XCTAssertEqual(
            l1.frame,
            CGRect(
                x: layoutRect.origin.x
                    + l1.layoutMargins.left,
                y: layoutRect.origin.y
                    + l1.layoutMargins.top,
                width: maxWidth
                    - l1.horizontalMargins,
                height: maxHeight - l1.verticalMargins))
        XCTAssertEqual(
            l2.frame,
            CGRect(
                x: layoutRect.origin.x
                    + l2.layoutMargins.left,
                y: layoutRect.origin.y
                    + l2.layoutMargins.top,
                width: maxWidth
                    - l2.horizontalMargins,
                height: maxHeight
                    - l2.verticalMargins))
        XCTAssertEqual(
            l3.frame,
            CGRect(
                x: layoutRect.origin.x
                    + l3.layoutMargins.left,
                y: layoutRect.origin.y
                    + l3.layoutMargins.top,
                width: maxWidth
                    - l3.horizontalMargins,
                height: maxHeight
                    - l3.verticalMargins))
    }

    func testMeasures() {
        var layout = [l1, l2, l3]
            .layoutAsFrame()
        let size = layout.sizeThatFits(CGSize(
            width: 300,
            height: 200))

        let maxWidth = max(
            l1.width + l1.horizontalMargins,
            l2.width + l2.horizontalMargins,
            l3.width + l3.horizontalMargins)
        let maxHeight = max(
            l1.height + l1.verticalMargins,
            l2.height + l2.verticalMargins,
            l3.height + l3.verticalMargins)

        XCTAssertEqual(size, CGSize(
            width: maxWidth,
            height: maxHeight))
    }
}

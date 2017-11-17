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

        l1.bayaMargins = UIEdgeInsets(
            top: 8,
            left: 7,
            bottom: 4,
            right: 3)
        l2.bayaMargins = UIEdgeInsets(
            top: 20,
            left: 50,
            bottom: 23,
            right: 12)
        l3.bayaMargins = UIEdgeInsets.zero
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
                    + l2.bayaMargins.left,
                y: layoutRect.origin.y
                    + l2.bayaMargins.top,
                width: l2.width,
                height: l2.height))
        XCTAssertEqual(
            l1.frame,
            CGRect(
                x: layoutRect.origin.x
                    + l1.bayaMargins.left,
                y: layoutRect.origin.y
                    + l1.bayaMargins.top,
                width: l1.width,
                height: l1.height))
        XCTAssertEqual(
            l3.frame,
            CGRect(
                x: layoutRect.origin.x
                    + l3.bayaMargins.left,
                y: layoutRect.origin.y
                    + l3.bayaMargins.top,
                width: l3.width,
                height: l3.height))
    }

    func testSizesMatchingParent() {
        l1 = TestLayoutable(sideLength: 30, bayaModes: BayaLayoutOptions.Modes(width: .matchParent, height: .matchParent))
        l2 = TestLayoutable(sideLength: 60, bayaModes: BayaLayoutOptions.Modes(width: .matchParent, height: .matchParent))
        l3 = TestLayoutable(sideLength: 90, bayaModes: BayaLayoutOptions.Modes(width: .matchParent, height: .matchParent))
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
                    + l1.bayaMargins.left,
                y: layoutRect.origin.y
                    + l1.bayaMargins.top,
                width: maxWidth
                    - l1.horizontalMargins,
                height: maxHeight - l1.verticalMargins))
        XCTAssertEqual(
            l2.frame,
            CGRect(
                x: layoutRect.origin.x
                    + l2.bayaMargins.left,
                y: layoutRect.origin.y
                    + l2.bayaMargins.top,
                width: maxWidth
                    - l2.horizontalMargins,
                height: maxHeight
                    - l2.verticalMargins))
        XCTAssertEqual(
            l3.frame,
            CGRect(
                x: layoutRect.origin.x
                    + l3.bayaMargins.left,
                y: layoutRect.origin.y
                    + l3.bayaMargins.top,
                width: maxWidth
                    - l3.horizontalMargins,
                height: maxHeight
                    - l3.verticalMargins))
    }
    
    func testMatchingParentWithMargins() {
        let l = TestLayoutable(sideLength: 90, bayaModes: BayaLayoutOptions.Modes(width: .matchParent, height: .matchParent))
        l.bayaMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        let layoutRect = CGRect(
            x: 5,
            y: 10,
            width: 300,
            height: 300)
        var layout = [l].layoutAsFrame()
        layout.layoutWith(frame: layoutRect) // Skips the first measure step
        
        XCTAssertEqual(
            l.frame,
            CGRect(
                x: 5 + 16,
                y: 10 + 16,
                width: layoutRect.width - l.horizontalMargins,
                height: layoutRect.height - l.verticalMargins))
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

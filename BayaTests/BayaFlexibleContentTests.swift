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
            spacing: spacing,
            layoutMargins: UIEdgeInsets.zero)
        let measuredSize = layout.sizeThatFitsWithMargins(layoutRect.size)

        let requiredWidth = l1.width
            + l2.width
            + l3.width
            + l1.horizontalMargins
            + l2.horizontalMargins
            + l3.horizontalMargins
            + spacing * 2
        let requiredHeight = max(
            l1.height + l1.verticalMargins,
            l2.height + l2.verticalMargins,
            l3.height + l3.verticalMargins)
        
        XCTAssertEqual(measuredSize, CGSize(width: requiredWidth, height: requiredHeight))
    }

    func testMeasureVertical() {
        var layout = l2.layoutFlexible(
            elementBefore: l1,
            elementAfter: l3,
            orientation: .vertical,
            spacing: spacing,
            layoutMargins: UIEdgeInsets.zero)
        let measuredSize = layout.sizeThatFitsWithMargins(layoutRect.size)

        let requiredHeight = l1.height
            + l2.height
            + l3.height
            + l1.verticalMargins
            + l2.verticalMargins
            + l3.verticalMargins
            + spacing * 2
        let requiredWidth = max(
            l1.width + l1.horizontalMargins,
            l2.width + l2.horizontalMargins,
            l3.width + l3.horizontalMargins)

        XCTAssertEqual(measuredSize, CGSize(width: requiredWidth, height: requiredHeight))
    }

    func testHorizontal() {
        var layout = l2.layoutFlexible(
            elementBefore: l1,
            elementAfter: l3,
            orientation: .horizontal,
            spacing: spacing,
            layoutMargins: UIEdgeInsets.zero)
        layout.startLayout(with: layoutRect)

        let requiredWidth = l1.width
            + l2.width
            + l3.width
            + l1.horizontalMargins
            + l2.horizontalMargins
            + l3.horizontalMargins
            + spacing * 2

        XCTAssertEqual(
            l1.frame,
            CGRect(
                x: layoutRect.minX + l1.layoutMargins.left,
                y: layoutRect.minY + l1.layoutMargins.top,
                width: l1.width,
                height: l1.height))
        XCTAssertEqual(
            l3.frame,
            CGRect(
                x: layoutRect.minX + requiredWidth - l3.width - l3.layoutMargins.right,
                y: layoutRect.minY + l3.layoutMargins.top,
                width: l3.width,
                height: l3.height))
        XCTAssertEqual(
            l2.frame,
            CGRect(
                x: layoutRect.minX + l1.width + l1.horizontalMargins + spacing + l2.layoutMargins.left,
                y: layoutRect.minY + l2.layoutMargins.top,
                width: l2.width,
                height: l2.height))
    }

    func testHorizontalLargeFrame() {
        var layout = l2.layoutFlexible(
            elementBefore: l1,
            elementAfter: l3,
            orientation: .horizontal,
            spacing: spacing)
        layout.layoutWith(frame: layoutRect)
        
        XCTAssertEqual(
            l1.frame,
            CGRect(
                x: layoutRect.minX
                    + l1.layoutMargins.left,
                y: layoutRect.minY
                    + l1.layoutMargins.top,
                width: l1.width,
                height: l1.height))
        XCTAssertEqual(
            l2.frame,
            CGRect(
                x: layoutRect.minX
                    + l1.horizontalMargins
                    + l1.width
                    + spacing
                    + l2.layoutMargins.left,
                y: layoutRect.minY
                    + l2.layoutMargins.top,
                width: l2.width,
                height: l2.height))
        XCTAssertEqual(
            l3.frame,
            CGRect(
                x: layoutRect.maxX
                    - l3.width
                    - l3.layoutMargins.right,
                y: layoutRect.minY
                    + l3.layoutMargins.top,
                width: l3.width,
                height: l3.height))
    }
    
    func testHorizontalMatchParent() {
        l1 = TestLayoutable(sideLength: 40, layoutModes: BayaLayoutOptions.Modes(width: .matchParent, height: .matchParent))
        l2 = TestLayoutable(sideLength: 60, layoutModes: BayaLayoutOptions.Modes(width: .matchParent, height: .matchParent))
        l3 = TestLayoutable(sideLength: 100, layoutModes: BayaLayoutOptions.Modes(width: .matchParent, height: .matchParent))
        
        var layout = l2.layoutFlexible(
            elementBefore: l1,
            elementAfter: l3,
            orientation: .horizontal,
            spacing: spacing)
        layout.startLayout(with: layoutRect)
        
        let requiredWidth = l1.width
            + l2.width
            + l3.width
            + l1.horizontalMargins
            + l2.horizontalMargins
            + l3.horizontalMargins
            + spacing * 2
        let maxHeight = max(
            l1.height + l1.verticalMargins,
            l2.height + l2.verticalMargins,
            l3.height + l3.verticalMargins)
        
        XCTAssertEqual(
            l1.frame,
            CGRect(
                x: layoutRect.minX + l1.layoutMargins.left,
                y: layoutRect.minY + l1.layoutMargins.top,
                width: l1.width,
                height: maxHeight - l1.verticalMargins))
        XCTAssertEqual(
            l2.frame, CGRect(
                x: layoutRect.minX
                    + l1.width
                    + l1.horizontalMargins
                    + spacing
                    + l2.layoutMargins.left,
                y: layoutRect.minY,
                width: l2.width,
                height: maxHeight - l2.verticalMargins))
        XCTAssertEqual(
            l3.frame, CGRect(
                x: layoutRect.minX
                    + requiredWidth
                    - l3.width
                    - l3.layoutMargins.right,
                y: layoutRect.minY
                    + l3.layoutMargins.top,
                width: l3.width,
                height: maxHeight - l3.verticalMargins))
    }
    
    func testHorizontalLargeFrameMatchParent() {
        l1 = TestLayoutable(sideLength: 40, layoutModes: BayaLayoutOptions.Modes(width: .matchParent, height: .matchParent))
        l2 = TestLayoutable(sideLength: 70, layoutModes: BayaLayoutOptions.Modes(width: .matchParent, height: .matchParent))
        l3 = TestLayoutable(sideLength: 100, layoutModes: BayaLayoutOptions.Modes(width: .matchParent, height: .matchParent))
        
        var layout = l2.layoutFlexible(
            elementBefore: l1,
            elementAfter: l3,
            orientation: .horizontal,
            spacing: spacing)
        layout.layoutWith(frame: layoutRect)
        
        XCTAssertEqual(
            l1.frame,
            CGRect(
                x: layoutRect.minX
                    + l1.layoutMargins.left,
                y: layoutRect.minY
                    + l1.layoutMargins.top,
                width: l1.width,
                height: layoutRect.height
                    - l1.verticalMargins))
        XCTAssertEqual(
            l2.frame,
            CGRect(
                x: layoutRect.minX
                    + l1.horizontalMargins
                    + l1.width
                    + spacing
                    + l2.layoutMargins.left,
                y: layoutRect.minY
                    + l2.layoutMargins.top,
                width: layoutRect.width
                    - l1.width
                    - l1.horizontalMargins
                    - spacing
                    - l2.horizontalMargins
                    - spacing
                    - l3.width
                    - l3.horizontalMargins,
                height: layoutRect.height
                    - l2.verticalMargins))
        XCTAssertEqual(
            l3.frame,
            CGRect(
                x: layoutRect.maxX
                    - l3.width
                    - l3.layoutMargins.right,
                y: layoutRect.minY
                    + l3.layoutMargins.top,
                width: l3.width,
                height: layoutRect.height
                    - l3.verticalMargins))
    }

    func testVertical() {
        var layout = l2.layoutFlexible(
            elementBefore: l1,
            elementAfter: l3,
            orientation: .vertical,
            spacing: spacing,
            layoutMargins: UIEdgeInsets.zero)
        layout.startLayout(with: layoutRect)

        let requiredHeight = l1.height
            + l2.height
            + l3.height
            + l1.verticalMargins
            + l2.verticalMargins
            + l3.verticalMargins
            + spacing * 2

        XCTAssertEqual(
            l1.frame,
            CGRect(
                x: layoutRect.minX + l1.layoutMargins.left,
                y: layoutRect.minY + l1.layoutMargins.top,
                width: l1.width,
                height: l1.height))
        XCTAssertEqual(
            l3.frame,
            CGRect(
                x: layoutRect.minX + l3.layoutMargins.left,
                y: layoutRect.minY + requiredHeight - l3.height - l3.layoutMargins.bottom,
                width: l3.width,
                height: l3.height))
        XCTAssertEqual(
            l2.frame,
            CGRect(
                x: layoutRect.minX + l2.layoutMargins.left,
                y: layoutRect.minY + l1.height + l1.verticalMargins + spacing + l2.layoutMargins.top,
                width: l2.width,
                height: l2.height))
    }
    
    func testVerticalLargeFrame() {
        var layout = l2.layoutFlexible(
            elementBefore: l1,
            elementAfter: l3,
            orientation: .vertical,
            spacing: spacing)
        layout.layoutWith(frame: layoutRect)
        
        XCTAssertEqual(
            l1.frame,
            CGRect(
                x: layoutRect.minX
                    + l1.layoutMargins.left,
                y: layoutRect.minY
                    + l1.layoutMargins.top,
                width: l1.width,
                height: l1.height))
        XCTAssertEqual(
            l2.frame,
            CGRect(
                x: layoutRect.minX
                    + l2.layoutMargins.left,
                y: layoutRect.minY
                    + l1.verticalMargins
                    + l1.height
                    + spacing
                    + l2.layoutMargins.top,
                width: l2.width,
                height: l2.height))
        XCTAssertEqual(
            l3.frame,
            CGRect(
                x: layoutRect.minX
                    + l3.layoutMargins.left,
                y: layoutRect.maxY
                    - l3.height
                    - l3.layoutMargins.bottom,
                width: l3.width,
                height: l3.height))
    }
    
    func testVerticalMatchParent() {
        l1 = TestLayoutable(sideLength: 40, layoutModes: BayaLayoutOptions.Modes(width: .matchParent, height: .matchParent))
        l2 = TestLayoutable(sideLength: 70, layoutModes: BayaLayoutOptions.Modes(width: .matchParent, height: .matchParent))
        l3 = TestLayoutable(sideLength: 100, layoutModes: BayaLayoutOptions.Modes(width: .matchParent, height: .matchParent))
        
        var layout = l2.layoutFlexible(
            elementBefore: l1,
            elementAfter: l3,
            orientation: .vertical,
            spacing: spacing)
        layout.startLayout(with: layoutRect)
        
        let requiredHeight = l1.height
            + l2.height
            + l3.height
            + l1.verticalMargins
            + l2.verticalMargins
            + l3.verticalMargins
            + spacing * 2
        let maxWidth = max(l1.width + l1.horizontalMargins,
            l2.width + l2.horizontalMargins,
            l3.width + l3.horizontalMargins)
        
        XCTAssertEqual(
            l1.frame,
            CGRect(
                x: layoutRect.minX
                    + l1.layoutMargins.left,
                y: layoutRect.minY
                    + l1.layoutMargins.top,
                width: maxWidth
                    - l1.horizontalMargins,
                height: l1.height))
        XCTAssertEqual(
            l3.frame,
            CGRect(
                x: layoutRect.minX
                    + l3.layoutMargins.left,
                y: layoutRect.minY
                    + requiredHeight
                    - l3.height
                    - l3.layoutMargins.bottom,
                width: maxWidth
                    - l3.horizontalMargins,
                height: l3.height))
        XCTAssertEqual(
            l2.frame,
            CGRect(
                x: layoutRect.minX
                    + l2.layoutMargins.left,
                y: layoutRect.minY
                    + l1.height
                    + l1.verticalMargins
                    + spacing
                    + l2.layoutMargins.top,
                width: maxWidth
                    - l2.horizontalMargins,
                height: l2.height))
    }
    
    func testVerticalLargeFrameMatchParent() {
        l1 = TestLayoutable(sideLength: 40, layoutModes: BayaLayoutOptions.Modes(width: .matchParent, height: .matchParent))
        l2 = TestLayoutable(sideLength: 70, layoutModes: BayaLayoutOptions.Modes(width: .matchParent, height: .matchParent))
        l3 = TestLayoutable(sideLength: 100, layoutModes: BayaLayoutOptions.Modes(width: .matchParent, height: .matchParent))
        
        var layout = l2.layoutFlexible(
            elementBefore: l1,
            elementAfter: l3,
            orientation: .vertical,
            spacing: spacing)
        layout.layoutWith(frame: layoutRect)
        
        XCTAssertEqual(
            l1.frame,
            CGRect(
                x: layoutRect.minX
                    + l1.layoutMargins.left,
                y: layoutRect.minY
                    + l1.layoutMargins.top,
                width: layoutRect.width
                    - l1.horizontalMargins,
                height: l1.height))
        XCTAssertEqual(
            l2.frame,
            CGRect(
                x: layoutRect.minX
                    + l2.layoutMargins.left,
                y: layoutRect.minY
                    + l1.height
                    + l1.verticalMargins
                    + spacing
                    + l2.layoutMargins.top,
                width: layoutRect.width
                    - l2.horizontalMargins,
                height: layoutRect.height
                    - l1.height
                    - l1.verticalMargins
                    - l2.verticalMargins
                    - l3.height
                    - l3.verticalMargins
                    - spacing * 2))
        XCTAssertEqual(
            l3.frame,
            CGRect(
                x: layoutRect.minX
                    + l3.layoutMargins.right,
                y: layoutRect.maxY
                    - l3.height
                    - l3.layoutMargins.bottom,
                width: layoutRect.width
                    - l3.horizontalMargins,
                height: l3.height))
    }

    func testHorizontalWithNoOptionalElements() {
        var layout = l2.layoutFlexible(
            elementBefore: nil,
            elementAfter: nil,
            orientation: .horizontal,
            spacing: spacing,
            layoutMargins: UIEdgeInsets.zero)
        layout.startLayout(with: layoutRect)

        XCTAssertEqual(
            l2.frame,
            CGRect(
                x: layoutRect.minX + l2.layoutMargins.left,
                y: layoutRect.minY + l2.layoutMargins.top,
                width: l2.width,
                height: l2.height))
    }

    func testVerticalWithNoOptionalElements() {
        var layout = l2.layoutFlexible(
            elementBefore: nil,
            elementAfter: nil,
            orientation: .vertical,
            spacing: spacing,
            layoutMargins: UIEdgeInsets.zero)
        layout.startLayout(with: layoutRect)

        XCTAssertEqual(
            l2.frame,
            CGRect(
                x: layoutRect.minX + l2.layoutMargins.left,
                y: layoutRect.minY + l2.layoutMargins.top,
                width: l2.width,
                height: l2.height))
    }
}

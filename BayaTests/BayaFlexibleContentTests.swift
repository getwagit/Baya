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
            spacing: spacing,
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
            spacing: spacing,
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
                width: l1.sideLength,
                height: l1.sideLength))
        XCTAssertEqual(
            l2.frame,
            CGRect(
                x: layoutRect.minX
                    + l1.horizontalMargins
                    + l1.sideLength
                    + spacing
                    + l2.layoutMargins.left,
                y: layoutRect.minY
                    + l2.layoutMargins.top,
                width: l2.sideLength,
                height: l2.sideLength))
        XCTAssertEqual(
            l3.frame,
            CGRect(x: layoutRect.maxX
                - l3.sideLength
                - l3.layoutMargins.right,
                   y: layoutRect.minY
                    + l3.layoutMargins.top,
                   width: l3.sideLength,
                   height: l3.sideLength))
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
        
        let requiredWidth = l1.sideLength
            + l2.sideLength
            + l3.sideLength
            + l1.horizontalMargins
            + l2.horizontalMargins
            + l3.horizontalMargins
            + spacing * 2
        let maxHeight = max(
            l1.sideLength + l1.verticalMargins,
            l2.sideLength + l2.verticalMargins,
            l3.sideLength + l3.verticalMargins)
        
        XCTAssertEqual(
            l1.frame,
            CGRect(
                x: layoutRect.minX + l1.layoutMargins.left,
                y: layoutRect.minY + l1.layoutMargins.top,
                width: l1.sideLength,
                height: maxHeight - l1.verticalMargins))
        XCTAssertEqual(
            l2.frame, CGRect(
                x: layoutRect.minX
                    + l1.sideLength
                    + l1.horizontalMargins
                    + spacing
                    + l2.layoutMargins.left,
                y: layoutRect.minY,
                width: l2.sideLength,
                height: maxHeight - l2.verticalMargins))
        XCTAssertEqual(
            l3.frame, CGRect(
                x: layoutRect.minX
                    + requiredWidth
                    - l3.sideLength
                    - l3.layoutMargins.right,
                y: layoutRect.minY
                    + l3.layoutMargins.top,
                width: l3.sideLength,
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
        
        let maxHeight = max(
            l1.sideLength + l1.verticalMargins,
            l2.sideLength + l2.verticalMargins,
            l3.sideLength + l3.verticalMargins)
        
        XCTAssertEqual(
            l1.frame,
            CGRect(
                x: layoutRect.minX
                    + l1.layoutMargins.left,
                y: layoutRect.minY
                    + l1.layoutMargins.top,
                width: l1.sideLength,
                height: maxHeight
                    - l1.verticalMargins))
        XCTAssertEqual(
            l2.frame,
            CGRect(
                x: layoutRect.minX
                    + l1.horizontalMargins
                    + l1.sideLength
                    + spacing
                    + l2.layoutMargins.left,
                y: layoutRect.minY
                    + l2.layoutMargins.top,
                width: layoutRect.width
                    - l1.sideLength
                    - l1.horizontalMargins
                    - spacing
                    - l2.horizontalMargins
                    - spacing
                    - l3.sideLength
                    - l3.horizontalMargins,
                height: maxHeight
                    - l2.verticalMargins))
        XCTAssertEqual(
            l3.frame,
            CGRect(
                x: layoutRect.maxX
                    - l3.sideLength
                    - l3.layoutMargins.right,
                y: layoutRect.minY
                    + l3.layoutMargins.top,
                width: l3.sideLength,
                height: maxHeight
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
                width: l1.sideLength,
                height: l1.sideLength))
        XCTAssertEqual(
            l2.frame,
            CGRect(
                x: layoutRect.minX
                    + l2.layoutMargins.left,
                y: layoutRect.minY
                    + l1.verticalMargins
                    + l1.sideLength
                    + spacing
                    + l2.layoutMargins.top,
                width: l2.sideLength,
                height: l2.sideLength))
        XCTAssertEqual(
            l3.frame,
            CGRect(
                x: layoutRect.minX
                    + l3.layoutMargins.left,
                y: layoutRect.maxY
                    - l3.sideLength
                    - l3.layoutMargins.bottom,
                width: l3.sideLength,
                height: l3.sideLength))
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
        
        let requiredHeight = l1.sideLength
            + l2.sideLength
            + l3.sideLength
            + l1.verticalMargins
            + l2.verticalMargins
            + l3.verticalMargins
            + spacing * 2
        let maxWidth = max(l1.sideLength + l1.horizontalMargins,
            l2.sideLength + l2.horizontalMargins,
            l3.sideLength + l3.horizontalMargins)
        
        XCTAssertEqual(
            l1.frame,
            CGRect(
                x: layoutRect.minX
                    + l1.layoutMargins.left,
                y: layoutRect.minY
                    + l1.layoutMargins.top,
                width: maxWidth
                    - l1.horizontalMargins,
                height: l1.sideLength))
        XCTAssertEqual(
            l3.frame,
            CGRect(
                x: layoutRect.minX
                    + l3.layoutMargins.left,
                y: layoutRect.minY
                    + requiredHeight
                    - l3.sideLength
                    - l3.layoutMargins.bottom,
                width: maxWidth
                    - l3.horizontalMargins,
                height: l3.sideLength))
        XCTAssertEqual(
            l2.frame,
            CGRect(
                x: layoutRect.minX
                    + l2.layoutMargins.left,
                y: layoutRect.minY
                    + l1.sideLength
                    + l1.verticalMargins
                    + spacing
                    + l2.layoutMargins.top,
                width: maxWidth
                    - l2.horizontalMargins,
                height: l2.sideLength))
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
        
        let maxWidth = max(
            l1.sideLength + l1.horizontalMargins,
            l2.sideLength + l2.horizontalMargins,
            l3.sideLength + l3.horizontalMargins)
        
        XCTAssertEqual(
            l1.frame,
            CGRect(
                x: layoutRect.minX
                    + l1.layoutMargins.left,
                y: layoutRect.minY
                    + l1.layoutMargins.top,
                width: maxWidth
                    - l1.horizontalMargins,
                height: l1.sideLength))
        XCTAssertEqual(
            l2.frame,
            CGRect(
                x: layoutRect.minX
                    + l2.layoutMargins.left,
                y: layoutRect.minY
                    + l1.sideLength
                    + l1.verticalMargins
                    + spacing
                    + l2.layoutMargins.top,
                width: maxWidth
                    - l2.horizontalMargins,
                height: layoutRect.height
                    - l1.sideLength
                    - l1.verticalMargins
                    - l2.verticalMargins
                    - l3.sideLength
                    - l3.verticalMargins
                    - spacing * 2))
        XCTAssertEqual(
            l3.frame,
            CGRect(
                x: layoutRect.minX
                    + l3.layoutMargins.right,
                y: layoutRect.maxY
                    - l3.sideLength
                    - l3.layoutMargins.bottom,
                width: maxWidth
                    - l3.horizontalMargins,
                height: l3.sideLength))
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
                width: l2.sideLength,
                height: l2.sideLength))
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
                width: l2.sideLength,
                height: l2.sideLength))
    }
}

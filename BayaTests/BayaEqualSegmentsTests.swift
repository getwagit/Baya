//
// Copyright (c) 2017 wag it GmbH.
// License: MIT
//

import XCTest
@testable import Baya

class BayaEqualSegmentsTests: XCTestCase {
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
        width: 100,
        height: 100)
    let spacing: CGFloat = 10

    override func setUp() {
        super.setUp()
        l1 = TestLayoutable(sideLength: 30)
        l2 = TestLayoutable(sideLength: 60)
        l3 = TestLayoutable(sideLength: 90)

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

    func testEmptyArray() {
        var layout = [BayaLayoutable]()
            .layoutAsEqualSegments(
                orientation: .horizontal,
                spacing: spacing)
        layout.startLayout(
            with: CGRect())
        XCTAssert(true) // Does not crash.
    }

    func testHorizontal() {
        var layout = [l1, l2, l3]
            .layoutAsEqualSegments(
                orientation: .horizontal,
                spacing: spacing)
        layout.startLayout(with: layoutRect)
        let availableSideLength = (l3.width + l3.horizontalMargins) // Largest element as base.

        XCTAssertEqual(l1.frame, CGRect(
            x: layoutRect.origin.x + l1.layoutMargins.left,
            y: layoutRect.origin.y + l1.layoutMargins.top,
            width: l1.width,
            height: l1.height))
        XCTAssertEqual(l2.frame, CGRect(
            x: layoutRect.origin.x
                + availableSideLength
                + spacing
                + l2.layoutMargins.left,
            y: layoutRect.origin.y + l2.layoutMargins.top,
            width: l2.width,
            height: l2.height))
        XCTAssertEqual(l3.frame,CGRect(
            x: layoutRect.origin.x
                + availableSideLength * 2
                + spacing * 2
                + l3.layoutMargins.left,
            y: layoutRect.origin.y + l3.layoutMargins.top,
            width: l3.width,
            height: l3.height))
    }
    
    func testHorizontalMatchingParent() {
        l1 = TestLayoutable(sideLength: 30, layoutModes: BayaLayoutOptions.Modes(width: .matchParent, height: .matchParent))
        l2 = TestLayoutable(sideLength: 60, layoutModes: BayaLayoutOptions.Modes(width: .matchParent, height: .matchParent))
        l3 = TestLayoutable(sideLength: 90, layoutModes: BayaLayoutOptions.Modes(width: .matchParent, height: .matchParent))
        l1.m(1, 2, 3, 4)
        l2.m(5, 6, 7, 8)
        l3.m(9, 10, 11, 12)
        var layout = [l1, l2, l3]
            .layoutAsEqualSegments(
                orientation: .horizontal,
                spacing: spacing)

        layout.startLayout(with: layoutRect)
        let maxHeight = max(
            l1.height + l1.verticalMargins,
            l2.height + l2.verticalMargins,
            l3.height + l3.verticalMargins)
        let maxWidth = max(
            l1.width + l1.horizontalMargins,
            l2.width + l2.horizontalMargins,
            l3.width + l3.horizontalMargins)
        
        XCTAssertEqual(
            l1.frame,
            CGRect(
                x: layoutRect.minX + l1.layoutMargins.left,
                y: layoutRect.minY + l1.layoutMargins.top,
                width: maxWidth - l1.horizontalMargins,
                height: maxHeight - l1.verticalMargins))
        XCTAssertEqual(
            l2.frame,
            CGRect(
                x: layoutRect.minX
                    + maxWidth
                    + spacing
                    + l2.layoutMargins.left,
                y: layoutRect.minY + l2.layoutMargins.top,
                width: maxWidth - l2.horizontalMargins,
                height: maxHeight - l2.verticalMargins))
        XCTAssertEqual(
            l3.frame,
            CGRect(
                x: layoutRect.minX
                    + maxWidth * 2
                    + spacing * 2
                    + l3.layoutMargins.left,
                y: layoutRect.minY + l3.layoutMargins.top,
                width: maxWidth - l3.horizontalMargins,
                height: maxHeight - l3.verticalMargins))
    }

    func testHorizontalBigEnforcedFrame() {
        var layout = [l1, l2, l3]
            .layoutAsEqualSegments(
                orientation: .horizontal,
                spacing: spacing)

        layout.layoutWith(frame: layoutRect)
        let availableSideLength = (layoutRect.width - spacing * 2) / 3 // Rect dictates the size
        
        XCTAssertEqual(
            l1.frame,
            CGRect(
                x: layoutRect.minX + l1.layoutMargins.left,
                y: layoutRect.minY + l1.layoutMargins.top,
                width: l1.width,
                height: l1.height))
        XCTAssertEqual(
            l2.frame,
            CGRect(
                x: layoutRect.minX
                    + availableSideLength
                    + spacing
                    + l2.layoutMargins.left,
                y: layoutRect.minY + l2.layoutMargins.top,
                width: l2.width,
                height: l2.height))
        XCTAssertEqual(
            l3.frame,
            CGRect(
                x: layoutRect.minX
                    + availableSideLength * 2
                    + spacing * 2
                    + l3.layoutMargins.left,
                y: layoutRect.minY + l3.layoutMargins.top,
                width: l3.width,
                height: l3.height))
    }
    
    func testHorizontalBigEnforcedFrameMatchingParent() {
        l1 = TestLayoutable(sideLength: 30, layoutModes: BayaLayoutOptions.Modes(width: .matchParent, height: .matchParent))
        l2 = TestLayoutable(sideLength: 60, layoutModes: BayaLayoutOptions.Modes(width: .matchParent, height: .matchParent))
        l3 = TestLayoutable(sideLength: 90, layoutModes: BayaLayoutOptions.Modes(width: .matchParent, height: .matchParent))
        l1.m(1, 2, 3, 4)
        l2.m(5, 6, 7, 8)
        l3.m(9, 10, 11, 12)
        
        var layout = [l1, l2, l3]
            .layoutAsEqualSegments(
                orientation: .horizontal,
                spacing: spacing)
        
        layout.layoutWith(frame: layoutRect)
        let availableSideLength = (layoutRect.width - spacing * 2) / 3 // Rect dictates the size
        
        XCTAssertEqual(
            l1.frame,
            CGRect(
                x: layoutRect.minX + l1.layoutMargins.left,
                y: layoutRect.minY + l1.layoutMargins.top,
                width: availableSideLength - l1.horizontalMargins,
                height: layoutRect.height - l1.verticalMargins))
        XCTAssertEqual(
            l2.frame,
            CGRect(
                x: layoutRect.minX
                    + availableSideLength
                    + spacing
                    + l2.layoutMargins.left,
                y: layoutRect.minY + l2.layoutMargins.top,
                width: availableSideLength - l2.horizontalMargins,
                height: layoutRect.height - l2.verticalMargins))
        XCTAssertEqual(
            l3.frame,
            CGRect(
                x: layoutRect.minX
                    + availableSideLength * 2
                    + spacing * 2
                    + l3.layoutMargins.left,
                y: layoutRect.minY + l3.layoutMargins.top,
                width: availableSideLength - l3.horizontalMargins,
                height: layoutRect.height - l3.verticalMargins))
    }

    func testHorizontalSmallEnforcedFrame() {
        var layout = [l1, l2, l3]
            .layoutAsEqualSegments(
                orientation: .horizontal,
                spacing: spacing)
        
        layout.startLayout(with: layoutRectTooSmall)
        let availableSideLength = (layoutRectTooSmall.width - spacing * 2) / 3 // Rect now dictates the size
        
        XCTAssertEqual(
            l1.frame,
            CGRect(
                x: layoutRectTooSmall.origin.x + l1.layoutMargins.left,
                y: layoutRectTooSmall.origin.y + l1.layoutMargins.top,
                width: l1.width,
                height: l1.height))
        XCTAssertEqual(
            l2.frame,
            CGRect(
                x: layoutRectTooSmall.origin.x
                    + availableSideLength
                    + spacing
                    + l2.layoutMargins.left,
                y: layoutRectTooSmall.origin.y + l2.layoutMargins.top,
                width: l2.width,
                height: l2.height))
        XCTAssertEqual(
            l3.frame,
            CGRect(
                x: layoutRectTooSmall.origin.x
                    + availableSideLength * 2
                    + spacing * 2
                    + l3.layoutMargins.left,
                y: layoutRectTooSmall.origin.y + l3.layoutMargins.top,
                width: l3.width,
                height: l3.height))
    }
    
    func testHorizontalSmallEnforcedFrameMatchingParent() {
        l1 = TestLayoutable(sideLength: 30, layoutModes: BayaLayoutOptions.Modes(width: .matchParent, height: .matchParent))
        l2 = TestLayoutable(sideLength: 60, layoutModes: BayaLayoutOptions.Modes(width: .matchParent, height: .matchParent))
        l3 = TestLayoutable(sideLength: 90, layoutModes: BayaLayoutOptions.Modes(width: .matchParent, height: .matchParent))
        var layout = [l1, l2, l3]
            .layoutAsEqualSegments(
                orientation: .horizontal,
                spacing: spacing)

        let maxHeight = max(
            l1.height + l1.verticalMargins,
            l2.height + l2.verticalMargins,
            l3.height + l3.verticalMargins)
        
        layout.startLayout(with: layoutRectTooSmall)
        let availableSideLength = (layoutRectTooSmall.width - spacing * 2) / 3 // Rect now dictates the size
        
        XCTAssertEqual(
            l1.frame,
            CGRect(
                x: layoutRectTooSmall.origin.x + l1.layoutMargins.left,
                y: layoutRectTooSmall.origin.y + l1.layoutMargins.top,
                width: availableSideLength - l1.horizontalMargins,
                height: maxHeight - l1.verticalMargins))
        XCTAssertEqual(
            l2.frame,
            CGRect(
                x: layoutRectTooSmall.origin.x
                    + availableSideLength
                    + spacing
                    + l2.layoutMargins.left,
                y: layoutRectTooSmall.origin.y + l2.layoutMargins.top,
                width: availableSideLength - l2.horizontalMargins,
                height: maxHeight - l2.verticalMargins))
        XCTAssertEqual(
            l3.frame,
            CGRect(
                x: layoutRectTooSmall.origin.x
                    + availableSideLength * 2
                    + spacing * 2
                    + l3.layoutMargins.left,
                y: layoutRectTooSmall.origin.y + l3.layoutMargins.top,
                width: availableSideLength - l3.horizontalMargins,
                height: maxHeight - l3.verticalMargins))
    }
    

    func testVertical() {
        var layout = [l1, l2, l3]
            .layoutAsEqualSegments(
                orientation: .vertical,
                spacing: spacing)
        
        layout.startLayout(with: layoutRect)
        let availableSideLength = (l3.height + l3.verticalMargins) // Largest element as base.
        
        XCTAssertEqual(
            l1.frame,
            CGRect(
                x: layoutRect.origin.x + l1.layoutMargins.left,
                y: layoutRect.origin.y + l1.layoutMargins.top,
                width: l1.width,
                height: l1.height))
        XCTAssertEqual(
            l2.frame,
            CGRect(
                x: layoutRect.origin.x + l2.layoutMargins.left,
                y: layoutRect.origin.y
                    + availableSideLength
                    + spacing
                    + l2.layoutMargins.top,
                width: l2.width,
                height: l2.height))
        XCTAssertEqual(
            l3.frame,
            CGRect(
                x: layoutRect.origin.x + l3.layoutMargins.left,
                y: layoutRect.origin.y
                    + availableSideLength * 2
                    + spacing * 2
                    + l3.layoutMargins.top,
                width: l3.width,
                height: l3.height))
    }

    func testVerticalMatchingParent() {
        l1 = TestLayoutable(sideLength: 30, layoutModes: BayaLayoutOptions.Modes(width: .matchParent, height: .matchParent))
        l2 = TestLayoutable(sideLength: 60, layoutModes: BayaLayoutOptions.Modes(width: .matchParent, height: .matchParent))
        l3 = TestLayoutable(sideLength: 90, layoutModes: BayaLayoutOptions.Modes(width: .matchParent, height: .matchParent))
        var layout = [l1, l2, l3]
            .layoutAsEqualSegments(
            orientation: .vertical,
            spacing: spacing)
        
        layout.startLayout(with: layoutRect)
        let maxHeight = max(
            l1.height + l1.verticalMargins,
            l2.height + l2.verticalMargins,
            l3.height + l3.verticalMargins)
        let maxWidth = max(
            l1.width + l1.horizontalMargins,
            l2.width + l2.horizontalMargins,
            l3.width + l3.horizontalMargins)
        
        XCTAssertEqual(
            l1.frame,
            CGRect(
                x: layoutRect.minX + l1.layoutMargins.left,
                y: layoutRect.minY + l1.layoutMargins.top,
                width: maxWidth - l1.horizontalMargins,
                height: maxHeight - l1.verticalMargins))
        XCTAssertEqual(
            l2.frame,
            CGRect(
                x: layoutRect.minX + l2.layoutMargins.left,
                y: layoutRect.minY
                    + maxHeight
                    + spacing
                    + l2.layoutMargins.top,
                width: maxWidth - l2.horizontalMargins,
                height: maxHeight - l2.verticalMargins))
        XCTAssertEqual(
            l3.frame,
            CGRect(
                x: layoutRect.minX + l3.layoutMargins.left,
                y: layoutRect.minY
                    + maxHeight * 2
                    + spacing * 2
                    + l3.layoutMargins.top,
                width: maxWidth - l3.horizontalMargins,
                height: maxHeight - l3.verticalMargins))
    }
    
    func testVerticalBigEnforcedFrame() {
        var layout = [l1, l2, l3]
            .layoutAsEqualSegments(
                orientation: .vertical,
                spacing: spacing)
        
        layout.layoutWith(frame: layoutRect)
        let availableSideLength = (layoutRect.width - spacing * 2) / 3 // Rect dictates the size
        
        XCTAssertEqual(
            l1.frame,
            CGRect(
                x: layoutRect.minX + l1.layoutMargins.left,
                y: layoutRect.minY + l1.layoutMargins.top,
                width: l1.width,
                height: l1.height))
        XCTAssertEqual(
            l2.frame,
            CGRect(
                x: layoutRect.minX + l2.layoutMargins.left,
                y: layoutRect.minY
                    + availableSideLength
                    + spacing
                    + l2.layoutMargins.top,
                width: l2.width,
                height: l2.height))
        XCTAssertEqual(
            l3.frame,
            CGRect(
                x: layoutRect.minX + l3.layoutMargins.left,
                y: layoutRect.minY
                    + availableSideLength * 2
                    + spacing * 2
                    + l3.layoutMargins.top,
                width: l3.width,
                height: l3.height))
    }

    func testVerticalBigEnforcedFrameMatchingParent() {
        l1 = TestLayoutable(sideLength: 30, layoutModes: BayaLayoutOptions.Modes(width: .matchParent, height: .matchParent))
        l2 = TestLayoutable(sideLength: 60, layoutModes: BayaLayoutOptions.Modes(width: .matchParent, height: .matchParent))
        l3 = TestLayoutable(sideLength: 90, layoutModes: BayaLayoutOptions.Modes(width: .matchParent, height: .matchParent))
        l1.m(1, 2, 3, 4)
        l2.m(5, 6, 7, 8)
        l3.m(9, 10, 11, 12)
        
        var layout = [l1, l2, l3]
            .layoutAsEqualSegments(
                orientation: .vertical,
                spacing: spacing)
        
        layout.layoutWith(frame: layoutRect)
        
        let availableSideLength = (layoutRect.height - spacing * 2) / 3 // Rect dictates the size
        
        XCTAssertEqual(
            l1.frame,
            CGRect(
                x: layoutRect.minX + l1.layoutMargins.left,
                y: layoutRect.minY + l1.layoutMargins.top,
                width: layoutRect.width - l1.horizontalMargins,
                height: availableSideLength - l1.verticalMargins))
        XCTAssertEqual(
            l2.frame,
            CGRect(
                x: layoutRect.minX + l2.layoutMargins.left,
                y: layoutRect.minY
                    + availableSideLength
                    + spacing
                    + l2.layoutMargins.top,
                width: layoutRect.width - l2.horizontalMargins,
                height: availableSideLength - l2.verticalMargins))
        XCTAssertEqual(
            l3.frame,
            CGRect(
                x: layoutRect.minX + l3.layoutMargins.left,
                y: layoutRect.minY
                    + availableSideLength * 2
                    + spacing * 2
                    + l3.layoutMargins.top,
                width: layoutRect.width - l3.horizontalMargins,
                height: availableSideLength - l3.verticalMargins))
    }

    func testVerticalSmallEnforcedFrame() {
        var layout = [l1, l2, l3]
            .layoutAsEqualSegments(
            orientation: .vertical,
            spacing: spacing)

        layout.startLayout(with: layoutRectTooSmall)
        let availableSideLength = (layoutRectTooSmall.height - spacing * 2) / 3 // Rect now dictates the size

        XCTAssertEqual(
            l1.frame,
            CGRect(
                x: layoutRectTooSmall.origin.x + l1.layoutMargins.left,
                y: layoutRectTooSmall.origin.y + l1.layoutMargins.top,
                width: l1.width,
                height: l1.height))
        XCTAssertEqual(
            l2.frame,
            CGRect(
                x: layoutRectTooSmall.origin.x + l2.layoutMargins.left,
                y: layoutRectTooSmall.origin.y
                    + availableSideLength
                    + spacing
                    + l2.layoutMargins.top,
                width: l2.width,
                height: l2.height))
        XCTAssertEqual(
            l3.frame,
            CGRect(
                x: layoutRectTooSmall.origin.x + l3.layoutMargins.left,
                y: layoutRectTooSmall.origin.y
                    + availableSideLength * 2
                    + spacing * 2
                    + l3.layoutMargins.top,
                width: l3.width,
                height: l3.height))
    }

    func testVerticalSmallEnforcedFrameMatchingParent() {
        l1 = TestLayoutable(sideLength: 30, layoutModes: BayaLayoutOptions.Modes(width: .matchParent, height: .matchParent))
        l2 = TestLayoutable(sideLength: 60, layoutModes: BayaLayoutOptions.Modes(width: .matchParent, height: .matchParent))
        l3 = TestLayoutable(sideLength: 90, layoutModes: BayaLayoutOptions.Modes(width: .matchParent, height: .matchParent))
        var layout = [l1, l2, l3]
            .layoutAsEqualSegments(
                orientation: .vertical,
                spacing: spacing)

        let maxWidth = max(
            l1.width + l1.horizontalMargins,
            l2.width + l2.horizontalMargins,
            l3.width + l3.horizontalMargins)
        
        layout.startLayout(with: layoutRectTooSmall)
        let availableSideLength = (layoutRectTooSmall.height - spacing * 2) / 3 // Rect now dictates the size
        
        XCTAssertEqual(
            l1.frame,
            CGRect(
                x: layoutRectTooSmall.origin.x + l1.layoutMargins.left,
                y: layoutRectTooSmall.origin.y + l1.layoutMargins.top,
                width: maxWidth - l1.horizontalMargins,
                height: availableSideLength - l1.verticalMargins))
        XCTAssertEqual(
            l2.frame,
            CGRect(
                x: layoutRectTooSmall.origin.x + l2.layoutMargins.left,
                y: layoutRectTooSmall.origin.y
                    + availableSideLength
                    + spacing
                    + l2.layoutMargins.top,
                width: maxWidth - l2.horizontalMargins,
                height: availableSideLength - l1.verticalMargins))
        XCTAssertEqual(
            l3.frame,
            CGRect(
                x: layoutRectTooSmall.origin.x + l3.layoutMargins.left,
                y: layoutRectTooSmall.origin.y
                    + availableSideLength * 2
                    + spacing * 2
                    + l2.layoutMargins.top,
                width: maxWidth - l3.horizontalMargins,
                height: availableSideLength - l3.verticalMargins))
    }

    func testMeasureHorizontal() {
        var layout = [l1, l2, l3].layoutAsEqualSegments(
            orientation: .horizontal,
            spacing: spacing)

        let maxHeight = max(
            l1.height + l1.verticalMargins,
            l2.height + l2.verticalMargins,
            l3.height + l3.verticalMargins)
        let maxWidth = max(
            l1.width + l1.horizontalMargins,
            l2.width + l2.horizontalMargins,
            l3.width + l3.horizontalMargins)

        let targetSize = CGSize(
            width: maxWidth * 3 + spacing * 2,
            height: maxHeight)
        let size1 = layout.sizeThatFits(CGSize(width: 400, height: 300))
        let size2 = layout.sizeThatFits(CGSize(width: 200, height: 30))

        XCTAssertEqual(size1, targetSize,
            "bigger size does not match")
        XCTAssertEqual(size2, targetSize,
            "smaller size does not match")
    }

    func testMeasureVertical() {
        var layout = [l1, l2, l3].layoutAsEqualSegments(
            orientation: .vertical,
            spacing: spacing)

        let maxHeight = max(
            l1.height + l1.verticalMargins,
            l2.height + l2.verticalMargins,
            l3.height + l3.verticalMargins)
        let maxWidth = max(
            l1.width + l1.horizontalMargins,
            l2.width + l2.horizontalMargins,
            l3.width + l3.horizontalMargins)
        
        let targetSize = CGSize(
            width: maxWidth,
            height: maxHeight * 3 + spacing * 2)
        let size1 = layout.sizeThatFits(CGSize(width: 400, height: 300))
        let size2 = layout.sizeThatFits(CGSize(width: 10, height: 30))

        XCTAssertEqual(size1, targetSize,
            "bigger size does not match")
        XCTAssertEqual(size2, targetSize,
            "smaller size does not match")
    }

    func testDifferentTypesPossible() {
        let anotherOne = AnotherOne()
        var layout = [l1, anotherOne].layoutAsEqualSegments(orientation: .horizontal)
        layout.startLayout(with: layoutRect)
        XCTAssert(true)
    }
}

private class AnotherOne: BayaLayoutable {
    var layoutMargins = UIEdgeInsets.zero
    var frame = CGRect()

    func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: 30, height: 30)
    }

    func layoutWith(frame: CGRect) {
        self.frame = frame
    }
}

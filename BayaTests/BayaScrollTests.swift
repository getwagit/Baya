//
// Copyright (c) 2017 wag it GmbH.
// License: MIT
//

import Foundation
import XCTest
@testable import Baya

class BayaScrollTests: XCTestCase {
    var content: TestLayoutable!
    var container: TestScrollLayoutContainer!
    let layoutRect = CGRect(x: 3, y: 4, width: 300, height: 400)

    override func setUp() {
        super.setUp()
        content = TestLayoutable()
        content.m(1, 2, 3, 4)
        container = TestScrollLayoutContainer()
        container.m(5, 6, 7, 8)
    }

    override func tearDown() {
        super.tearDown()
        content = nil
        container = nil
    }

    func testSmallTestContentMeasuresCorrectly() {
        content = TestLayoutable(sideLength: 20)
        content.m(1, 2, 3, 4)
        var layout = content.layoutScrollContent(container: container)
        let measure = layout.sizeThatFits(layoutRect.size)

        XCTAssertEqual(
            measure,
            CGSize(
                width: content.sideLength + content.horizontalMargins + container.horizontalMargins,
                height: content.sideLength + content.verticalMargins + container.verticalMargins),
            "size does not match")
    }

    func testLargeTestContentMeasureIsLimitedByFrameSize() {
        content = TestLayoutable(sideLength: 1345)
        content.m(1, 3, 4, 5)
        var layout = content.layoutScrollContent(container: container)
        let measure = layout.sizeThatFits(layoutRect.size)

        XCTAssertEqual(
            measure,
            CGSize(
                width: layoutRect.width,
                height: layoutRect.height),
            "size does not match")
    }

    func testHorizontalBigContent() {
        content = TestLayoutable(sideLength: 1000)
        var layout = content.layoutScrollContent(container: container, orientation: .horizontal)
        layout.startLayout(with: layoutRect)
        
        XCTAssertEqual(
            content.frame,
            CGRect(
                x: container.bounds.minX + content.layoutMargins.left,
                y: container.bounds.minY + content.layoutMargins.top,
                width: content.sideLength,
                height: content.sideLength))
        XCTAssertEqual(
            container.frame,
            CGRect(
                x: layoutRect.minX + container.layoutMargins.left,
                y: layoutRect.minY + container.layoutMargins.top,
                width: layoutRect.width - container.horizontalMargins,
                height: layoutRect.height - container.verticalMargins))
        XCTAssertEqual(
            container.contentSize,
            CGSize(
                width: content.sideLength + content.horizontalMargins,
                height: content.sideLength + content.verticalMargins))
    }
    
    func testHorizontalSmallContent() {
        content = TestLayoutable(sideLength: 80)
        content.m(1, 2, 3, 4)
        var layout = content.layoutScrollContent(container: container, orientation: .horizontal)
        layout.startLayout(with: layoutRect)
        
        XCTAssertEqual(
            content.frame,
            CGRect(
                x: container.bounds.minX + content.layoutMargins.left,
                y: container.bounds.minY + content.layoutMargins.top,
                width: content.sideLength,
                height: content.sideLength))
        XCTAssertEqual(
            container.frame,
            CGRect(
                x: layoutRect.minX + container.layoutMargins.left,
                y: layoutRect.minY + container.layoutMargins.top,
                width: content.widthWithMargins,
                height: content.heightWithMargins))
        XCTAssertEqual(
            container.contentSize,
            CGSize(
                width: content.widthWithMargins,
                height: content.heightWithMargins))
    }
    
    func testHorizontalSmallContentMatchParent() {
        content = TestLayoutable(sideLength: 80, layoutModes: BayaLayoutOptions.Modes(width: .matchParent, height: .matchParent))
        content.m(1, 2, 3, 4)
        var layout = content.layoutScrollContent(container: container, orientation: .horizontal)
        layout.startLayout(with: layoutRect)
        
        XCTAssertEqual(
            content.frame,
            CGRect(
                x: container.bounds.minX + content.layoutMargins.left,
                y: container.bounds.minY + content.layoutMargins.top,
                width: layoutRect.width - content.horizontalMargins - container.horizontalMargins,
                height: layoutRect.height - content.verticalMargins - container.verticalMargins))
        XCTAssertEqual(
            container.frame,
            CGRect(
                x: layoutRect.minX + container.layoutMargins.left,
                y: layoutRect.minY + container.layoutMargins.top,
                width: layoutRect.width - container.horizontalMargins,
                height: layoutRect.height - container.verticalMargins))
        XCTAssertEqual(
            container.contentSize,
            CGSize(
                width: layoutRect.width - container.horizontalMargins,
                height: layoutRect.height - container.verticalMargins))
    }
    
    func testVerticalBigContent() {
        content = TestLayoutable(sideLength: 1200)
        content.m(1, 2, 3, 4)
        var layout = content.layoutScrollContent(container: container, orientation: .vertical)
        layout.startLayout(with: layoutRect)
        
        XCTAssertEqual(
            content.frame,
            CGRect(
                x: container.bounds.minX + content.layoutMargins.left,
                y: container.bounds.minY + content.layoutMargins.top,
                width: content.sideLength,
                height: content.sideLength))
        XCTAssertEqual(
            container.frame,
            CGRect(
                x: layoutRect.minX + container.layoutMargins.left,
                y: layoutRect.minY + container.layoutMargins.top,
                width: layoutRect.width - container.horizontalMargins,
                height: layoutRect.height - container.verticalMargins))
        XCTAssertEqual(
            container.contentSize,
            CGSize(
                width: content.sideLength + content.horizontalMargins,
                height: content.sideLength + content.verticalMargins))
    }
    
    func testVerticalSmallContent() {
        content = TestLayoutable(sideLength: 100)
        content.m(1, 2, 3, 4)
        var layout = content.layoutScrollContent(container: container, orientation: .vertical)
        layout.startLayout(with: layoutRect)
        
        XCTAssertEqual(
            content.frame,
            CGRect(
                x: container.bounds.minX + content.layoutMargins.left,
                y: container.bounds.minY + content.layoutMargins.top,
                width: content.sideLength,
                height: content.sideLength))
        XCTAssertEqual(
            container.frame,
            CGRect(
                x: layoutRect.minX + container.layoutMargins.left,
                y: layoutRect.minY + container.layoutMargins.top,
                width: content.sideLength + content.horizontalMargins,
                height: content.sideLength + content.verticalMargins))
        XCTAssertEqual(
            container.contentSize,
            CGSize(
                width: content.sideLength + content.horizontalMargins,
                height: content.sideLength + content.verticalMargins))
    }
    
    func testVerticalSmallContentMatchParent() {
        content = TestLayoutable(
            sideLength: 100,
            layoutModes: BayaLayoutOptions.Modes(width: .matchParent, height: .matchParent))
        content.m(1, 2, 3, 4)
        var layout = content.layoutScrollContent(container: container, orientation: .vertical)
        layout.startLayout(with: layoutRect)
        
        XCTAssertEqual(
            content.frame,
            CGRect(
                x: container.bounds.minX + content.layoutMargins.left,
                y: container.bounds.minY + content.layoutMargins.top,
                width: layoutRect.width - container.horizontalMargins - content.horizontalMargins,
                height: layoutRect.height - container.verticalMargins - content.verticalMargins))
        XCTAssertEqual(
            container.frame,
            CGRect(
                x: layoutRect.minX + container.layoutMargins.left,
                y: layoutRect.minY + container.layoutMargins.top,
                width: layoutRect.width - container.horizontalMargins,
                height: layoutRect.height - container.verticalMargins))
        XCTAssertEqual(
            container.contentSize,
            CGSize(
                width: layoutRect.width - container.horizontalMargins,
                height: layoutRect.height - container.verticalMargins))
    }
}

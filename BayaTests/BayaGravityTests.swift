//
// Copyright (c) 2017 wag it GmbH.
// License: MIT
//

import Foundation

import XCTest
@testable import Baya

class BayaGravityTests: XCTestCase {
    var l: TestLayoutable!
    let layoutRect = CGRect(x: 3, y: 4, width: 300, height: 400)
    
    override func setUp() {
        super.setUp()
        l = TestLayoutable()
        l.m(1, 2, 3, 4)
    }
    
    override func tearDown() {
        super.tearDown()
        l = nil
    }
    
    func testMeasureLeftTop() {
        var layout = l.layoutGravity(horizontally: .left, vertically: .top)
        let size = layout.sizeThatFits(layoutRect.size)
        XCTAssertEqual(
            size,
            CGSize(
                width: TestLayoutable.sideLength + l.horizontalMargins,
                height: TestLayoutable.sideLength + l.verticalMargins),
            "size does not match")
    }
    
    func testMeasureCenterTop() {
        var layout = l.layoutGravity(horizontally: .center, vertically: .top)
        let size = layout.sizeThatFits(layoutRect.size)
        XCTAssertEqual(
            size,
            CGSize(
                width: TestLayoutable.sideLength + l.horizontalMargins,
                height: TestLayoutable.sideLength + l.verticalMargins),
            "size does not match")
    }
    
    func testMeasureRightTop() {
        var layout = l.layoutGravity(horizontally: .right, vertically: .top)
        let size = layout.sizeThatFits(layoutRect.size)
        XCTAssertEqual(
            size,
            CGSize(
                width: TestLayoutable.sideLength + l.horizontalMargins,
                height: TestLayoutable.sideLength + l.verticalMargins),
            "size does not match")
    }
    
    func testMeasureLeftMiddle() {
        var layout = l.layoutGravity(horizontally: .left, vertically: .middle)
        let size = layout.sizeThatFits(layoutRect.size)
        XCTAssertEqual(
            size,
            CGSize(
                width: TestLayoutable.sideLength + l.horizontalMargins,
                height: TestLayoutable.sideLength + l.verticalMargins),
            "size does not match")
    }
    
    func testMeasureCenterMiddle() {
        var layout = l.layoutGravity(horizontally: .center, vertically: .middle)
        let size = layout.sizeThatFits(layoutRect.size)
        XCTAssertEqual(
            size,
            CGSize(
                width: TestLayoutable.sideLength + l.horizontalMargins,
                height: TestLayoutable.sideLength + l.verticalMargins),
            "size does not match")
    }
    
    func testMeasureRightMiddle() {
        var layout = l.layoutGravity(horizontally: .right, vertically: .middle)
        let size = layout.sizeThatFits(layoutRect.size)
        XCTAssertEqual(
            size,
            CGSize(
                width: TestLayoutable.sideLength + l.horizontalMargins,
                height: TestLayoutable.sideLength + l.verticalMargins),
            "size does not match")
    }
    
    func testMeasureLeftBottom() {
        var layout = l.layoutGravity(horizontally: .left, vertically: .bottom)
        let size = layout.sizeThatFits(layoutRect.size)
        XCTAssertEqual(
            size,
            CGSize(
                width: TestLayoutable.sideLength + l.horizontalMargins,
                height: TestLayoutable.sideLength + l.verticalMargins),
            "size does not match")
    }
    
    func testMeasureCenterBottom() {
        var layout = l.layoutGravity(horizontally: .center, vertically: .bottom)
        let size = layout.sizeThatFits(layoutRect.size)
        XCTAssertEqual(
            size,
            CGSize(
                width: TestLayoutable.sideLength + l.horizontalMargins,
                height: TestLayoutable.sideLength + l.verticalMargins),
            "size does not match")
    }
    
    func testMeasureRightBottom() {
        var layout = l.layoutGravity(horizontally: .right, vertically: .bottom)
        let size = layout.sizeThatFits(layoutRect.size)
        XCTAssertEqual(
            size,
            CGSize(
                width: TestLayoutable.sideLength + l.horizontalMargins,
                height: TestLayoutable.sideLength + l.verticalMargins),
            "size does not match")
    }
    
    func testLeftTop() {
        var layout = l
            .layoutGravity(horizontally: .left, vertically: .top)
        layout.startLayout(with: layoutRect)
        XCTAssertEqual(
            l.frame,
            CGRect(
                x: layoutRect.minX + l.layoutMargins.left,
                y: layoutRect.minY + l.layoutMargins.top,
                width: TestLayoutable.sideLength,
                height: TestLayoutable.sideLength),
            "frame not matching")
    }
    
    func testCenterTop() {
        var layout = l
            .layoutGravity(horizontally: .center, vertically: .top)
        layout.layoutWith(frame: layoutRect)
        XCTAssertEqual(
            l.frame,
            CGRect(
                x: layoutRect.midX - TestLayoutable.sideLength / 2 + l.layoutMargins.left - l.layoutMargins.right,
                y: layoutRect.minY + l.layoutMargins.top,
                width: TestLayoutable.sideLength,
                height: TestLayoutable.sideLength),
            "frame not matching")
    }
    
    func testRightTop() {
        var layout = l
            .layoutGravity(horizontally: .right, vertically: .top)
        layout.layoutWith(frame: layoutRect)
        XCTAssertEqual(
            l.frame,
            CGRect(
                x: layoutRect.maxX - TestLayoutable.sideLength - l.layoutMargins.right,
                y: layoutRect.minY + l.layoutMargins.top,
                width: TestLayoutable.sideLength,
                height: TestLayoutable.sideLength),
            "frame not matching")
    }
    
    
    func testLeftMiddle() {
        var layout = l
            .layoutGravity(horizontally: .left, vertically: .middle)
        layout.layoutWith(frame: layoutRect)
        XCTAssertEqual(
            l.frame,
            CGRect(
                x: layoutRect.minX + l.layoutMargins.left,
                y: layoutRect.midY - TestLayoutable.sideLength / 2 + l.layoutMargins.top - l.layoutMargins.bottom,
                width: TestLayoutable.sideLength,
                height: TestLayoutable.sideLength),
            "frame not matching")
    }
    
    func testCenterMiddle() {
        var layout = l
            .layoutGravity(horizontally: .center, vertically: .middle)
        layout.layoutWith(frame: layoutRect)
        XCTAssertEqual(
            l.frame,
            CGRect(
                x: layoutRect.midX - TestLayoutable.sideLength / 2 + l.layoutMargins.left - l.layoutMargins.right,
                y: layoutRect.midY - TestLayoutable.sideLength / 2 + l.layoutMargins.top - l.layoutMargins.bottom,
                width: TestLayoutable.sideLength,
                height: TestLayoutable.sideLength),
            "frame not matching")
    }
    
    func testRightMiddle() {
        var layout = l
            .layoutGravity(horizontally: .right, vertically: .middle)
        layout.layoutWith(frame: layoutRect)
        XCTAssertEqual(
            l.frame,
            CGRect(
                x: layoutRect.maxX - TestLayoutable.sideLength - l.layoutMargins.right,
                y: layoutRect.midY - TestLayoutable.sideLength / 2 + l.layoutMargins.top - l.layoutMargins.bottom,
                width: TestLayoutable.sideLength,
                height: TestLayoutable.sideLength),
            "frame not matching")
    }
    
    func testLeftBottom() {
        var layout = l
            .layoutGravity(horizontally: .left, vertically: .bottom)
        layout.layoutWith(frame: layoutRect)
        XCTAssertEqual(
            l.frame,
            CGRect(
                x: layoutRect.minX + l.layoutMargins.left,
                y: layoutRect.maxY - TestLayoutable.sideLength - l.layoutMargins.bottom,
                width: TestLayoutable.sideLength,
                height: TestLayoutable.sideLength),
            "frame not matching")
    }
    
    func testCenterBottom() {
        var layout = l
            .layoutGravity(horizontally: .center, vertically: .bottom)
        layout.layoutWith(frame: layoutRect)
        XCTAssertEqual(
            l.frame,
            CGRect(
                x: layoutRect.midX - TestLayoutable.sideLength / 2 + l.layoutMargins.left - l.layoutMargins.right,
                y: layoutRect.maxY - TestLayoutable.sideLength - l.layoutMargins.bottom,
                width: TestLayoutable.sideLength,
                height: TestLayoutable.sideLength),
            "frame not matching")
    }
    
    func testRightBottom() {
        var layout = l
            .layoutGravity(horizontally: .right, vertically: .bottom)
        layout.layoutWith(frame: layoutRect)
        XCTAssertEqual(
            l.frame,
            CGRect(
                x: layoutRect.maxX - TestLayoutable.sideLength - l.layoutMargins.right,
                y: layoutRect.maxY - TestLayoutable.sideLength - l.layoutMargins.bottom,
                width: TestLayoutable.sideLength,
                height: TestLayoutable.sideLength),
            "frame not matching")
    }
}

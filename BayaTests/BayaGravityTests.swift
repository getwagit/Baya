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
        var layout = l.layoutGravitating(horizontally: .left, vertically: .top)
        let size = layout.sizeThatFits(layoutRect.size)
        XCTAssertEqual(
            size,
            CGSize(
                width: l.width + l.horizontalMargins,
                height: l.height + l.verticalMargins),
            "size does not match")
    }
    
    func testMeasureCenterTop() {
        var layout = l.layoutGravitating(horizontally: .centerX, vertically: .top)
        let size = layout.sizeThatFits(layoutRect.size)
        XCTAssertEqual(
            size,
            CGSize(
                width: l.width + l.horizontalMargins,
                height: l.height + l.verticalMargins),
            "size does not match")
    }
    
    func testMeasureRightTop() {
        var layout = l.layoutGravitating(horizontally: .right, vertically: .top)
        let size = layout.sizeThatFits(layoutRect.size)
        XCTAssertEqual(
            size,
            CGSize(
                width: l.width + l.horizontalMargins,
                height: l.height + l.verticalMargins),
            "size does not match")
    }
    
    func testMeasureLeftMiddle() {
        var layout = l.layoutGravitating(horizontally: .left, vertically: .centerY)
        let size = layout.sizeThatFits(layoutRect.size)
        XCTAssertEqual(
            size,
            CGSize(
                width: l.width + l.horizontalMargins,
                height: l.height + l.verticalMargins),
            "size does not match")
    }
    
    func testMeasureCenterMiddle() {
        var layout = l.layoutGravitating(horizontally: .centerX, vertically: .centerY)
        let size = layout.sizeThatFits(layoutRect.size)
        XCTAssertEqual(
            size,
            CGSize(
                width: l.width + l.horizontalMargins,
                height: l.height + l.verticalMargins),
            "size does not match")
    }
    
    func testMeasureRightMiddle() {
        var layout = l.layoutGravitating(horizontally: .right, vertically: .centerY)
        let size = layout.sizeThatFits(layoutRect.size)
        XCTAssertEqual(
            size,
            CGSize(
                width: l.width + l.horizontalMargins,
                height: l.height + l.verticalMargins),
            "size does not match")
    }
    
    func testMeasureLeftBottom() {
        var layout = l.layoutGravitating(horizontally: .left, vertically: .bottom)
        let size = layout.sizeThatFits(layoutRect.size)
        XCTAssertEqual(
            size,
            CGSize(
                width: l.width + l.horizontalMargins,
                height: l.height + l.verticalMargins),
            "size does not match")
    }
    
    func testMeasureCenterBottom() {
        var layout = l.layoutGravitating(horizontally: .centerX, vertically: .bottom)
        let size = layout.sizeThatFits(layoutRect.size)
        XCTAssertEqual(
            size,
            CGSize(
                width: l.width + l.horizontalMargins,
                height: l.height + l.verticalMargins),
            "size does not match")
    }
    
    func testMeasureRightBottom() {
        var layout = l.layoutGravitating(horizontally: .right, vertically: .bottom)
        let size = layout.sizeThatFits(layoutRect.size)
        XCTAssertEqual(
            size,
            CGSize(
                width: l.width + l.horizontalMargins,
                height: l.height + l.verticalMargins),
            "size does not match")
    }
    
    func testLeftTop() {
        var layout = l
            .layoutGravitating(horizontally: .left, vertically: .top)
        layout.startLayout(with: layoutRect)
        XCTAssertEqual(
            l.frame,
            CGRect(
                x: layoutRect.minX + l.bayaMargins.left,
                y: layoutRect.minY + l.bayaMargins.top,
                width: l.width,
                height: l.height),
            "frame not matching")
    }
    
    func testCenterTop() {
        var layout = l
            .layoutGravitating(horizontally: .centerX, vertically: .top)
        layout.startLayout(with: layoutRect)
        XCTAssertEqual(
            l.frame,
            CGRect(
                x: layoutRect.midX - l.width / 2,
                y: layoutRect.minY + l.bayaMargins.top,
                width: l.width,
                height: l.height),
            "frame not matching")
    }
    
    func testRightTop() {
        var layout = l
            .layoutGravitating(horizontally: .right, vertically: .top)
        layout.startLayout(with: layoutRect)
        XCTAssertEqual(
            l.frame,
            CGRect(
                x: layoutRect.maxX - l.width - l.bayaMargins.right,
                y: layoutRect.minY + l.bayaMargins.top,
                width: l.width,
                height: l.height),
            "frame not matching")
    }
    
    
    func testLeftMiddle() {
        var layout = l
            .layoutGravitating(horizontally: .left, vertically: .centerY)
        layout.startLayout(with: layoutRect)
        XCTAssertEqual(
            l.frame,
            CGRect(
                x: layoutRect.minX + l.bayaMargins.left,
                y: layoutRect.midY - l.height / 2,
                width: l.width,
                height: l.height),
            "frame not matching")
    }
    
    func testCenterMiddle() {
        var layout = l
            .layoutGravitating(horizontally: .centerX, vertically: .centerY)
        layout.startLayout(with: layoutRect)
        XCTAssertEqual(
            l.frame,
            CGRect(
                x: layoutRect.midX - l.width / 2,
                y: layoutRect.midY - l.height / 2,
                width: l.width,
                height: l.height),
            "frame not matching")
    }
    
    func testRightMiddle() {
        var layout = l
            .layoutGravitating(horizontally: .right, vertically: .centerY)
        layout.startLayout(with: layoutRect)
        XCTAssertEqual(
            l.frame,
            CGRect(
                x: layoutRect.maxX - l.width - l.bayaMargins.right,
                y: layoutRect.midY - l.height / 2,
                width: l.width,
                height: l.height),
            "frame not matching")
    }
    
    func testLeftBottom() {
        var layout = l
            .layoutGravitating(horizontally: .left, vertically: .bottom)
        layout.startLayout(with: layoutRect)
        XCTAssertEqual(
            l.frame,
            CGRect(
                x: layoutRect.minX + l.bayaMargins.left,
                y: layoutRect.maxY - l.height - l.bayaMargins.bottom,
                width: l.width,
                height: l.height),
            "frame not matching")
    }
    
    func testCenterBottom() {
        var layout = l
            .layoutGravitating(horizontally: .centerX, vertically: .bottom)
        layout.startLayout(with: layoutRect)
        XCTAssertEqual(
            l.frame,
            CGRect(
                x: layoutRect.midX - l.width / 2,
                y: layoutRect.maxY - l.height - l.bayaMargins.bottom,
                width: l.width,
                height: l.height),
            "frame not matching")
    }
    
    func testRightBottom() {
        var layout = l
            .layoutGravitating(horizontally: .right, vertically: .bottom)
        layout.startLayout(with: layoutRect)
        XCTAssertEqual(
            l.frame,
            CGRect(
                x: layoutRect.maxX - l.width - l.bayaMargins.right,
                y: layoutRect.maxY - l.height - l.bayaMargins.bottom,
                width: l.width,
                height: l.height),
            "frame not matching")
    }
}

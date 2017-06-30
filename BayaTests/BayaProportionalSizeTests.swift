//
// Copyright (c) 2016-2017 wag it GmbH.
// License: MIT
//

import Foundation

import XCTest
@testable import Baya

class BayaProportionalSizeTests: XCTestCase {
    var l: TestLayoutable!
    let layoutRect = CGRect(x: 1, y: 2, width: 300, height: 400)
    
    override func setUp() {
        super.setUp()
        l = TestLayoutable(sideLength: 60)
        l.m(3, 4, 5, 6)
    }
    
    override func tearDown() {
        super.tearDown()
        l = nil
    }
    
    func testMeasureWidth() {
        let widthFactor: CGFloat = 1/2
        var layout = l.layoutWithPortion(ofWidth: widthFactor, ofHeight: nil)
        let fit = layout.sizeThatFits(layoutRect.size)
        XCTAssertEqual(
            fit,
            CGSize(
                width: layoutRect.width * widthFactor,
                height: l.sideLength))
    }
    
    func testMeasureHeight() {
        let heightFactor: CGFloat = 1/4
        var layout = l.layoutWithPortion(ofWidth: nil, ofHeight: heightFactor)
        let fit = layout.sizeThatFits(layoutRect.size)
        
        XCTAssertEqual(
            fit,
            CGSize(
                width: l.sideLength,
                height: layoutRect.height * heightFactor))
    }
    
    func testMeasureBoth() {
        let heightFactor: CGFloat = 3/4
        let widthFactor: CGFloat = 1/5
        var layout = l.layoutWithPortion(ofWidth: widthFactor, ofHeight: heightFactor)
        let fit = layout.sizeThatFits(layoutRect.size)
        
        XCTAssertEqual(
            fit,
            CGSize(
                width: layoutRect.width * widthFactor,
                height: layoutRect.height * heightFactor))
    }
    
    func testWidth() {
        let widthFactor: CGFloat = 5/8
        var layout = l.layoutWithPortion(ofWidth: widthFactor, ofHeight: nil)
        layout.startLayout(with: layoutRect)

        XCTAssertEqual(
            l.frame,
            CGRect(
                x: layoutRect.minX + l.layoutMargins.left,
                y: layoutRect.minY + l.layoutMargins.top,
                width: (layoutRect.width - l.horizontalMargins) * widthFactor,
                height: l.sideLength))
    }
    
    func testHeight() {
        let heightFactor: CGFloat = 3/5
        var layout = l.layoutWithPortion(ofWidth: nil, ofHeight: heightFactor)
        layout.startLayout(with: layoutRect)
        
        XCTAssertEqual(
            l.frame,
            CGRect(
                x: layoutRect.minX + l.layoutMargins.left,
                y: layoutRect.minY + l.layoutMargins.top,
                width: l.sideLength,
                height: (layoutRect.height - l.verticalMargins) * heightFactor))
    }
    
    func testBoth() {
        let widthFactor: CGFloat = 7/8
        let heightFactor: CGFloat = 3/5
        var layout = l.layoutWithPortion(ofWidth: widthFactor, ofHeight: heightFactor)
        layout.startLayout(with: layoutRect)
        
        XCTAssertEqual(
            l.frame,
            CGRect(
                x: layoutRect.minX + l.layoutMargins.left,
                y: layoutRect.minY + l.layoutMargins.top,
                width: (layoutRect.width - l.horizontalMargins) * widthFactor,
                height: (layoutRect.height - l.verticalMargins) * heightFactor))
    }
    
    func testIncreaseBoth() {
        let widthFactor: CGFloat = 3
        let heightFactor: CGFloat = 10
        var layout = l.layoutWithPortion(ofWidth: widthFactor, ofHeight: heightFactor)
        layout.startLayout(with: layoutRect)
        
        XCTAssertEqual(
            l.frame,
            CGRect(
                x: layoutRect.minX + l.layoutMargins.left,
                y: layoutRect.minY + l.layoutMargins.top,
                width: (layoutRect.width - l.horizontalMargins) * widthFactor,
                height: (layoutRect.height - l.verticalMargins) * heightFactor))
    }
}
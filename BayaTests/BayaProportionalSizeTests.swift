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
                height: l.height))
    }
    
    func testMeasureHeight() {
        let heightFactor: CGFloat = 1/4
        var layout = l.layoutWithPortion(ofWidth: nil, ofHeight: heightFactor)
        let fit = layout.sizeThatFits(layoutRect.size)

        XCTAssertEqual(
            fit,
            CGSize(
                width: l.width,
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
                x: layoutRect.minX + l.bayaMargins.left,
                y: layoutRect.minY + l.bayaMargins.top,
                width: (layoutRect.width - l.horizontalMargins) * widthFactor,
                height: l.height))
    }
    
    func testWidthMatchingParent() {
        l = TestLayoutable(
            width: 80,
            height: 90,
            bayaModes: BayaLayoutOptions.Modes(
                width: .matchParent,
                height: .matchParent))
        let widthFactor: CGFloat = 13/15
        var layout = l.layoutWithPortion(ofWidth: widthFactor, ofHeight: nil)
        layout.startLayout(with: layoutRect)
        
        XCTAssertEqual(
            l.frame,
            CGRect(
                x: layoutRect.minX + l.bayaMargins.left,
                y: layoutRect.minY + l.bayaMargins.top,
                width: (layoutRect.width - l.horizontalMargins) * widthFactor,
                height: layoutRect.height - l.verticalMargins))
    }
    
    func testHeight() {
        let heightFactor: CGFloat = 3/5
        var layout = l.layoutWithPortion(ofWidth: nil, ofHeight: heightFactor)
        layout.startLayout(with: layoutRect)
        
        XCTAssertEqual(
            l.frame,
            CGRect(
                x: layoutRect.minX + l.bayaMargins.left,
                y: layoutRect.minY + l.bayaMargins.top,
                width: l.width,
                height: (layoutRect.height - l.verticalMargins) * heightFactor))
    }
    
    func testHeightMatchingParent() {
        l = TestLayoutable(
            width: 80,
            height: 90,
            bayaModes: BayaLayoutOptions.Modes(
                width: .matchParent,
                height: .matchParent))
        let heightFactor: CGFloat = 3/5
        var layout = l.layoutWithPortion(ofWidth: nil, ofHeight: heightFactor)
        layout.startLayout(with: layoutRect)
        
        XCTAssertEqual(
            l.frame,
            CGRect(
                x: layoutRect.minX + l.bayaMargins.left,
                y: layoutRect.minY + l.bayaMargins.top,
                width: layoutRect.width - l.horizontalMargins,
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
                x: layoutRect.minX + l.bayaMargins.left,
                y: layoutRect.minY + l.bayaMargins.top,
                width: (layoutRect.width - l.horizontalMargins) * widthFactor,
                height: (layoutRect.height - l.verticalMargins) * heightFactor))
    }
    
    func testFactorsLargerThanOneAreIgnored() {
        let widthFactor: CGFloat = 3
        let heightFactor: CGFloat = 10
        var layout = l.layoutWithPortion(ofWidth: widthFactor, ofHeight: heightFactor)
        layout.startLayout(with: layoutRect)
        
        XCTAssertEqual(
            l.frame,
            CGRect(
                x: layoutRect.minX + l.bayaMargins.left,
                y: layoutRect.minY + l.bayaMargins.top,
                width: (layoutRect.width - l.horizontalMargins),
                height: (layoutRect.height - l.verticalMargins)))
    }
    
    func testProportionalWidthWhenMeasureSkipped() {
        let widthFactor: CGFloat = 1/2
        var layout = l.layoutWithPortion(ofWidth: widthFactor)
        layout.layoutWith(frame: layoutRect)
        
        XCTAssertEqual(
            l.frame.size,
            CGSize(
                width: layoutRect.width * widthFactor,
                height: l.height))
    }
    
    func testProportionalHeightWhenMeasureSkipped() {
        let heightFactor: CGFloat = 1/5
        var layout = l.layoutWithPortion(ofHeight: heightFactor)
        layout.layoutWith(frame: layoutRect)
        
        XCTAssertEqual(
            l.frame.size,
            CGSize(
                width: l.width,
                height: layoutRect.height * heightFactor))
    }
    
    func testProportionalSizeWhenMeasureSkipped() {
        let widthFactor: CGFloat = 1/3
        let heightFactor: CGFloat = 11/12
        var layout = l.layoutWithPortion(ofWidth: widthFactor, ofHeight: heightFactor)
        layout.layoutWith(frame: layoutRect)
        
        XCTAssertEqual(
            l.frame.size,
            CGSize(
                width: layoutRect.width * widthFactor,
                height: layoutRect.height * heightFactor))
    }
    
    func testProportionalSizeMatchingParentWhenMeasureSkipped() {
        l = TestLayoutable(
            width: 100,
            height: 133,
            bayaModes: BayaLayoutOptions.Modes(
                width: .matchParent,
                height: .matchParent))
        let widthFactor: CGFloat = 1/3
        let heightFactor: CGFloat = 11/12
        var layout = l.layoutWithPortion(ofWidth: widthFactor, ofHeight: heightFactor)
        layout.layoutWith(frame: layoutRect)
        
        XCTAssertEqual(
            l.frame.size,
            CGSize(
                width: layoutRect.width * widthFactor,
                height: layoutRect.height * heightFactor))
    }
    
    func testProportionalMeasurementHorizontal() {
        l = ProportionalMeasureSquareTestLayoutable(squaredBasedOn: .horizontal)
        var layout = l.layoutWithPortion(ofWidth: 0.6)
        let measure = layout.sizeThatFits(layoutRect.size)
        
        XCTAssertEqual(
            measure.height,
            layoutRect.width * 0.6,
            "unexpected width")
    }
    
    func testProportionalMeasurementVertical() {
        l = ProportionalMeasureSquareTestLayoutable(squaredBasedOn: .vertical)
        var layout = l.layoutWithPortion(ofHeight: 0.36)
        let measure = layout.sizeThatFits(layoutRect.size)
        
        XCTAssertEqual(
            measure.width,
            layoutRect.height * 0.36,
            "unexpected height")
    }
}

class ProportionalMeasureSquareTestLayoutable: TestLayoutable {
    private let baseSide: BayaLayoutOptions.Orientation
    
    init(squaredBasedOn: BayaLayoutOptions.Orientation) {
        baseSide = squaredBasedOn
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        switch baseSide {
        case .horizontal:
            return CGSize(width: size.width, height: size.width)
        case .vertical:
            return CGSize(width: size.height, height: size.height)
        }
        
    }
}

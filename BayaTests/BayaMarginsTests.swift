//
// Copyright (c) 2016-2017 wag it GmbH.
// License: MIT
//

import Foundation

import XCTest
@testable import Baya

class BayaMarginsTests: XCTestCase {
    var l: TestLayoutable!
    var layoutRect = CGRect(x: 2, y: 4, width: 150, height: 300)
    
    override func setUp() {
        super.setUp()
        l = TestLayoutable(width: 100, height: 200)
        l.m(1, 2, 3, 4)
    }
    
    override func tearDown() {
        super.tearDown()
        l = nil
    }
    
    func testMeasure() {
        let margins = UIEdgeInsets(top: 6, left: 20, bottom: 18, right: 40)
        var layout = l.layoutWithMargins(bayaMargins: margins)
        let fit = layout.sizeThatFits(layoutRect.size)
        
        XCTAssertEqual(
            fit,
            CGSize(
                width: l.width,
                height: l.height))
        
        let smallLayoutRect = CGRect(x: 3, y: 6, width: 30, height: 50)
        let fitSmallRect = layout.sizeThatFits(smallLayoutRect.size)
        
        XCTAssertEqual(
            fitSmallRect,
            CGSize(
                width: l.width,
                height: l.height))
    }
    
    func testLayout() {
        let margins = UIEdgeInsets(top: 10, left: 20, bottom: 30, right: 40)
        var layout = l.layoutWithMargins(bayaMargins: margins)
        layout.startLayout(with: layoutRect)
        
        XCTAssertEqual(
            layout.bayaMargins,
            margins)
        
        XCTAssertEqual(
            l.frame,
            CGRect(
                x: layoutRect.minX + margins.left,
                y: layoutRect.minY + margins.top,
                width: l.width,
                height: l.height))
    }
    
    func testLayoutMatchingParent() {
        let margins = UIEdgeInsets(top: 7, left: 14, bottom: 21, right: 28)
        l = TestLayoutable(
            width: 80,
            height: 60,
            bayaModes: BayaLayoutOptions.Modes(
                width: .matchParent,
                height: .matchParent))
        l.m(1, 2, 3, 4)
        var layout = l.layoutWithMargins(bayaMargins: margins)
        layout.startLayout(with: layoutRect)
        
        XCTAssertEqual(
            layout.bayaMargins,
            margins)
        
        XCTAssertEqual(
            l.frame,
            CGRect(
                x: layoutRect.minX + margins.left,
                y: layoutRect.minY + margins.top,
                width: layoutRect.width - margins.left - margins.right,
                height: layoutRect.height - margins.top - margins.bottom))
    }
}

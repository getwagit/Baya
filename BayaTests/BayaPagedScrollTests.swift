//
// Copyright (c) 2017 wag it GmbH.
// License: MIT
//

import Foundation

import XCTest
@testable import Baya

class BayaPagedScrollTests: XCTestCase {
    var l: TestLayoutable!
    fileprivate var c: TestPagedScrollLayoutContainer!
    var layoutRect = CGRect(x: 3, y: 4, width: 400, height: 500)
    var pages: Int = 3
    var gutter: CGFloat = 20
    
    override func setUp() {
        super.setUp()
        l = TestLayoutable(sideLength: 60)
        c = TestPagedScrollLayoutContainer()
        l.m(1, 2, 3, 4)
        l.m(5, 6, 7, 8)
    }
    
    override func tearDown() {
        super.tearDown()
        l = nil
        c = nil
    }
    
    func testMeasureHorizontal() {
        let layout = l.layoutPagedScrollContent(container: c, pages: pages, orientation: .horizontal)
        let fit = layout.sizeThatFits(layoutRect.size)
        XCTAssertEqual(
            fit,
            layoutRect.size)
    }
    
    func testMeasureVertical() {
        let layout = l.layoutPagedScrollContent(container: c, pages: pages, orientation: .vertical)
        let fit = layout.sizeThatFits(layoutRect.size)
        XCTAssertEqual(
            fit,
            layoutRect.size)
    }
    
    func testHorizontal() {
        var layout = l.layoutPagedScrollContent(container: c, pages: pages, gutter: gutter, orientation: .horizontal)
        layout.startLayout(with: layoutRect)
        
        XCTAssertEqual(
            l.frame,
            CGRect(
                x: 0,
                y: 0,
                width: layoutRect.width * CGFloat(pages) + gutter * CGFloat(pages - 1),
                height: layoutRect.height))
        XCTAssertEqual(
            c.frame,
            CGRect(
                x: layoutRect.minX,
                y: layoutRect.minY,
                width: layoutRect.width + gutter,
                height: layoutRect.height))
        XCTAssertEqual(
            c.contentSize,
            CGSize(
                width: layoutRect.width * CGFloat(pages) + gutter * CGFloat(pages),
                height: layoutRect.height))
    }
    
    func testVertical() {
        var layout = l.layoutPagedScrollContent(container: c, pages: pages, gutter: gutter, orientation: .vertical)
        layout.startLayout(with: layoutRect)
        
        XCTAssertEqual(
            l.frame,
            CGRect(
                x: 0,
                y: 0,
                width: layoutRect.width,
                height: layout.frame.height * CGFloat(pages) + gutter * CGFloat(pages - 1)))
        XCTAssertEqual(
            c.frame,
            CGRect(
                x: layoutRect.minX,
                y: layoutRect.minY,
                width: layoutRect.width,
                height: layoutRect.height + gutter))
        XCTAssertEqual(
            c.contentSize,
            CGSize(
                width: layoutRect.width,
                height: layoutRect.height * CGFloat(pages) + gutter * CGFloat(pages)))
    }
}

private class TestPagedScrollLayoutContainer: TestLayoutable {
    var contentSize: CGSize = CGSize()
    var bounds: CGRect {
        return self.frame
    }
}

extension TestPagedScrollLayoutContainer: PagedScrollLayoutContainer {}

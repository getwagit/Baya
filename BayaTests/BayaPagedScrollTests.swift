//
// Copyright (c) 2017 wag it GmbH.
// License: MIT
//

import Foundation

import XCTest
@testable import Baya

class BayaPagedScrollTests: XCTestCase {
    var l: TestLayoutable!
    fileprivate var c: TestScrollLayoutContainer!
    var layoutRect = CGRect(x: 3, y: 4, width: 400, height: 500)
    var layoutRectTooSmall = CGRect(x: 1, y: 2, width: 40, height: 40)
    var pages: Int = 2
    var spacing: CGFloat = 20
    
    override func setUp() {
        super.setUp()
        l = TestLayoutable(sideLength: 60)
        c = TestScrollLayoutContainer()
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
        var layout = l.layoutPagedScrollContent(container: c, pages: pages, spacing: spacing, orientation: .horizontal)
        layout.startLayout(with: layoutRect)
        
        XCTAssertEqual(
            l.frame,
            CGRect(
                x: 0,
                y: 0,
                width: layoutRect.width * CGFloat(pages) + spacing * CGFloat(pages - 1),
                height: layoutRect.height))
        XCTAssertEqual(
            c.frame,
            CGRect(
                x: layoutRect.minX,
                y: layoutRect.minY,
                width: layoutRect.width + spacing,
                height: layoutRect.height))
        XCTAssertEqual(
            c.contentSize,
            CGSize(
                width: layoutRect.width * CGFloat(pages) + spacing * CGFloat(pages),
                height: layoutRect.height))
    }
    
    func testHorizontalMatchingParent() {
        l = TestLayoutable(
            sideLength: 50,
            bayaModes: BayaLayoutOptions.Modes(width: .matchParent, height: .matchParent))
        l.m(1, 2, 3, 4)
        var layout = l.layoutPagedScrollContent(container: c, pages: pages, spacing: spacing, orientation: .horizontal)
        layout.startLayout(with: layoutRect)
        
        XCTAssertEqual(
            l.frame,
            CGRect(
                x: 0,
                y: 0,
                width: layoutRect.width * CGFloat(pages) + spacing * CGFloat(pages - 1),
                height: layoutRect.height))
        XCTAssertEqual(
            c.frame,
            CGRect(
                x: layoutRect.minX,
                y: layoutRect.minY,
                width: layoutRect.width + spacing,
                height: layoutRect.height))
        XCTAssertEqual(
            c.contentSize,
            CGSize(
                width: layoutRect.width * CGFloat(pages) + spacing * CGFloat(pages),
                height: layoutRect.height))
    }
    
    func testHorizontalBigEnforcedFrame() {
        var layout = l.layoutPagedScrollContent(container: c, pages: pages, spacing: spacing, orientation: .horizontal)
        layout.layoutWith(frame: layoutRect)
        
        XCTAssertEqual(
            l.frame,
            CGRect(
                x: 0,
                y: 0,
                width: layoutRect.width * CGFloat(pages) + spacing * CGFloat(pages - 1),
                height: layoutRect.height))
        XCTAssertEqual(
            c.frame,
            CGRect(
                x: layoutRect.minX,
                y: layoutRect.minY,
                width: layoutRect.width + spacing,
                height: layoutRect.height))
        XCTAssertEqual(
            c.contentSize,
            CGSize(
                width: layoutRect.width * CGFloat(pages) + spacing * CGFloat(pages),
                height: layoutRect.height))
    }
    
    func testHorizontalBigEnforcedFrameMatchingParent() {
        l = TestLayoutable(
            sideLength: 50,
            bayaModes: BayaLayoutOptions.Modes(width: .matchParent, height: .matchParent))
        l.m(1, 2, 3, 4)

        var layout = l.layoutPagedScrollContent(container: c, pages: pages, spacing: spacing, orientation: .horizontal)
        layout.layoutWith(frame: layoutRect)
        
        XCTAssertEqual(
            l.frame,
            CGRect(
                x: 0,
                y: 0,
                width: layoutRect.width * CGFloat(pages) + spacing * CGFloat(pages - 1),
                height: layoutRect.height))
        XCTAssertEqual(
            c.frame,
            CGRect(
                x: layoutRect.minX,
                y: layoutRect.minY,
                width: layoutRect.width + spacing,
                height: layoutRect.height))
        XCTAssertEqual(
            c.contentSize,
            CGSize(
                width: layoutRect.width * CGFloat(pages) + spacing * CGFloat(pages),
                height: layoutRect.height))
    }
    
    func testHorizontalSmallEnforcedFrame() {
        var layout = l.layoutPagedScrollContent(container: c, pages: pages, spacing: spacing, orientation: .horizontal)
        layout.startLayout(with: layoutRectTooSmall)
        
        XCTAssertEqual(
            l.frame,
            CGRect(
                x: 0,
                y: 0,
                width: layoutRectTooSmall.width * CGFloat(pages) + spacing * CGFloat(pages - 1),
                height: layoutRectTooSmall.height))
        XCTAssertEqual(
            c.frame,
            CGRect(
                x: layoutRectTooSmall.minX,
                y: layoutRectTooSmall.minY,
                width: layoutRectTooSmall.width + spacing,
                height: layoutRectTooSmall.height))
        XCTAssertEqual(
            c.contentSize,
            CGSize(
                width: layoutRectTooSmall.width * CGFloat(pages) + spacing * CGFloat(pages),
                height: layoutRectTooSmall.height))
    }
    
    func testHorizontalSmallEnforcedFrameMatchingParent() {
        l = TestLayoutable(
            sideLength: 50,
            bayaModes: BayaLayoutOptions.Modes(width: .matchParent, height: .matchParent))
        l.m(1, 2, 3, 4)
        
        var layout = l.layoutPagedScrollContent(container: c, pages: pages, spacing: spacing, orientation: .horizontal)
        layout.startLayout(with: layoutRectTooSmall)
        
        XCTAssertEqual(
            l.frame,
            CGRect(
                x: 0,
                y: 0,
                width: layoutRectTooSmall.width * CGFloat(pages) + spacing * CGFloat(pages - 1),
                height: layoutRectTooSmall.height))
        XCTAssertEqual(
            c.frame,
            CGRect(
                x: layoutRectTooSmall.minX,
                y: layoutRectTooSmall.minY,
                width: layoutRectTooSmall.width + spacing,
                height: layoutRectTooSmall.height))
        XCTAssertEqual(
            c.contentSize,
            CGSize(
                width: layoutRectTooSmall.width * CGFloat(pages) + spacing * CGFloat(pages),
                height: layoutRectTooSmall.height))
    }
    
    func testVertical() {
        var layout = l.layoutPagedScrollContent(container: c, pages: pages, spacing: spacing, orientation: .vertical)
        layout.startLayout(with: layoutRect)
        
        XCTAssertEqual(
            l.frame,
            CGRect(
                x: 0,
                y: 0,
                width: layoutRect.width,
                height: layout.frame.height * CGFloat(pages) + spacing * CGFloat(pages - 1)))
        XCTAssertEqual(
            c.frame,
            CGRect(
                x: layoutRect.minX,
                y: layoutRect.minY,
                width: layoutRect.width,
                height: layoutRect.height + spacing))
        XCTAssertEqual(
            c.contentSize,
            CGSize(
                width: layoutRect.width,
                height: layoutRect.height * CGFloat(pages) + spacing * CGFloat(pages)))
    }
    
    func testVerticalMatchingParent() {
        l = TestLayoutable(
            sideLength: 50,
            bayaModes: BayaLayoutOptions.Modes(width: .matchParent, height: .matchParent))
        l.m(1, 2, 3, 4)
        var layout = l.layoutPagedScrollContent(container: c, pages: pages, spacing: spacing, orientation: .vertical)
        layout.startLayout(with: layoutRect)
        
        XCTAssertEqual(
            l.frame,
            CGRect(
                x: 0,
                y: 0,
                width: layoutRect.width,
                height: layout.frame.height * CGFloat(pages) + spacing * CGFloat(pages - 1)))
        XCTAssertEqual(
            c.frame,
            CGRect(
                x: layoutRect.minX,
                y: layoutRect.minY,
                width: layoutRect.width,
                height: layoutRect.height + spacing))
        XCTAssertEqual(
            c.contentSize,
            CGSize(
                width: layoutRect.width,
                height: layoutRect.height * CGFloat(pages) + spacing * CGFloat(pages)))
    }
    
    func testVerticalBigEnforcedFrame() {
        var layout = l.layoutPagedScrollContent(container: c, pages: pages, spacing: spacing, orientation: .vertical)
        layout.layoutWith(frame: layoutRect)
        
        XCTAssertEqual(
            l.frame,
            CGRect(
                x: 0,
                y: 0,
                width: layoutRect.width,
                height: layoutRect.height * CGFloat(pages) + spacing * CGFloat(pages - 1)))
        XCTAssertEqual(
            c.frame,
            CGRect(
                x: layoutRect.minX,
                y: layoutRect.minY,
                width: layoutRect.width,
                height: layoutRect.height + spacing))
        XCTAssertEqual(
            c.contentSize,
            CGSize(
                width: layoutRect.width,
                height: layoutRect.height * CGFloat(pages) + spacing * CGFloat(pages)))
    }
    
    func testVerticalBigEnforcedFrameMatchingParent() {
        l = TestLayoutable(
            sideLength: 50,
            bayaModes: BayaLayoutOptions.Modes(width: .matchParent, height: .matchParent))
        l.m(1, 2, 3, 4)
        
        var layout = l.layoutPagedScrollContent(container: c, pages: pages, spacing: spacing, orientation: .vertical)
        layout.layoutWith(frame: layoutRect)
        
        XCTAssertEqual(
            l.frame,
            CGRect(
                x: 0,
                y: 0,
                width: layoutRect.width,
                height: layoutRect.height * CGFloat(pages) + spacing * CGFloat(pages - 1)))
        XCTAssertEqual(
            c.frame,
            CGRect(
                x: layoutRect.minX,
                y: layoutRect.minY,
                width: layoutRect.width,
                height: layoutRect.height + spacing))
        XCTAssertEqual(
            c.contentSize,
            CGSize(
                width: layoutRect.width,
                height: layoutRect.height * CGFloat(pages) + spacing * CGFloat(pages)))
    }
    
    func testVerticalSmallEnforcedFrame() {
        var layout = l.layoutPagedScrollContent(container: c, pages: pages, spacing: spacing, orientation: .vertical)
        layout.startLayout(with: layoutRectTooSmall)
        
        XCTAssertEqual(
            l.frame,
            CGRect(
                x: 0,
                y: 0,
                width: layoutRectTooSmall.width,
                height: layoutRectTooSmall.height * CGFloat(pages) + spacing * CGFloat(pages - 1)))
        XCTAssertEqual(
            c.frame,
            CGRect(
                x: layoutRectTooSmall.minX,
                y: layoutRectTooSmall.minY,
                width: layoutRectTooSmall.width,
                height: layoutRectTooSmall.height + spacing))
        XCTAssertEqual(
            c.contentSize,
            CGSize(
                width: layoutRectTooSmall.width,
                height: layoutRectTooSmall.height * CGFloat(pages) + spacing * CGFloat(pages)))
    }
    
    func testVerticalSmallEnforcedFrameMatchingParent() {
        l = TestLayoutable(
            sideLength: 50,
            bayaModes: BayaLayoutOptions.Modes(width: .matchParent, height: .matchParent))
        l.m(1, 2, 3, 4)
        
        var layout = l.layoutPagedScrollContent(container: c, pages: pages, spacing: spacing, orientation: .vertical)
        layout.startLayout(with: layoutRectTooSmall)
        
        XCTAssertEqual(
            l.frame,
            CGRect(
                x: 0,
                y: 0,
                width: layoutRectTooSmall.width,
                height: layoutRectTooSmall.height * CGFloat(pages) + spacing * CGFloat(pages - 1)))
        XCTAssertEqual(
            c.frame,
            CGRect(
                x: layoutRectTooSmall.minX,
                y: layoutRectTooSmall.minY,
                width: layoutRectTooSmall.width,
                height: layoutRectTooSmall.height + spacing))
        XCTAssertEqual(
            c.contentSize,
            CGSize(
                width: layoutRectTooSmall.width,
                height: layoutRectTooSmall.height * CGFloat(pages) + spacing * CGFloat(pages)))
    }
}

//
// Copyright (c) 2017 wag it GmbH.
// License: MIT
//

import Foundation
import XCTest
@testable import Baya

class BayaOriginResetTests: XCTestCase {
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

    func testMeasure() {
        var layout = l.layoutResettingOrigin()
        let size = layout.sizeThatFits(layoutRect.size)
        XCTAssertEqual(
            size,
            CGSize(
                width: l.width,
                height: l.height),
            "size does not match")
    }

    func testResetsOrigin() {
        var layout = l.layoutResettingOrigin()
        l.frame.origin.x = 20;
        l.frame.origin.y = 31;
        layout.startLayout(with: layoutRect)
        XCTAssertEqual(
            l.frame,
            CGRect(
                x: 0,
                y: 0,
                width: l.width,
                height: l.height))
    }
    
    func testMemberMirroring() {
        l = TestLayoutable(bayaModes: BayaLayoutOptions.Modes(width: .matchParent, height: .matchParent))
        var layout = l.layoutResettingOrigin()
        layout.startLayout(with: layoutRect)
        XCTAssertEqual(
            l.bayaModes.height,
            layout.bayaModes.height)
        XCTAssertEqual(
            l.bayaModes.width,
            layout.bayaModes.width)
        XCTAssertEqual(
            l.bayaMargins,
            layout.bayaMargins)
        XCTAssertEqual(
            l.frame,
            layout.frame)
    }
}

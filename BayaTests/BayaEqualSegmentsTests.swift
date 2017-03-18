//
// Copyright (c) 2017 wag it GmbH.
// License: MIT
//

import XCTest
@testable import Baya

class BayaEqualSegmentsTests: XCTestCase {
    func testEqualSegmentsHorizontal() {
        let l1 = TestLayoutable()
        let l2 = TestLayoutable()
        let l3 = TestLayoutable()
        var layout = [l1, l2, l3]
            .equalSegments(orientation: .horizontal)

        layout.layoutWith(
            frame: CGRect(
                x: 5,
                y: 5,
                width: 300,
                height: 100))

        XCTAssert(l1.frame.size.width == 100)
        XCTAssert(l2.frame.size.width == 100)
        XCTAssert(l3.frame.size.width == 100)
        XCTAssert(l1.frame.size.height == 100)
    }

    func testEqualSegmentsVertical() {
        let l1 = TestLayoutable()
        let l2 = TestLayoutable()
        let l3 = TestLayoutable()
        var layout = [l1, l2, l3]
            .equalSegments(orientation: .vertical)

        layout.layoutWith(
            frame: CGRect(
                x: 5,
                y: 5,
                width: 100,
                height: 300))

        XCTAssert(l1.frame.size.height == 100)
        XCTAssert(l2.frame.size.height == 100)
        XCTAssert(l3.frame.size.height == 100)
        XCTAssert(l1.frame.size.width == 100)
    }
}
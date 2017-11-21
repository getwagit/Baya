//
// Copyright (c) 2017 wag it GmbH.
// License: MIT
//

import Foundation
import XCTest
@testable import Baya

class BayaConditionalTests: XCTestCase {
    var l: TestLayoutable!
    let layoutRect = CGRect(x: 5, y: 5, width: 300, height: 300)

    override func setUp() {
        super.setUp()
        l = TestLayoutable(sideLength: 60)
    }

    override func tearDown() {
        super.tearDown()
        l = nil
    }

    func testMeasureIfConditionIsMet() {
        var layout = l.layoutIf {
            true
        }
        let measure = layout.startMeasure(with: layoutRect.size)
        XCTAssertEqual(
            measure,
            CGSize(
                width: 60,
                height: 60))
    }

    func testMeasureMarginsIncluded() {
        l.bayaMargins = UIEdgeInsets(top: 3, left: 5, bottom: 4, right: 6)
        var layout = l.layoutIf {
            true
        }
        let measure = layout.startMeasure(with: layoutRect.size)
        XCTAssertEqual(
            measure,
            CGSize(
                width: 71,
                height: 67))
    }

    func testMeasureIfConditionIsNotMet() {
        l.bayaMargins = UIEdgeInsets(top: 3, left: 5, bottom: 4, right: 6)
        var layout = l.layoutIf {
            false
        }
        let measure = layout.startMeasure(with: layoutRect.size)
        XCTAssertEqual(
            measure,
            CGSize(
                width: 0,
                height: 0))
    }

    func testLayoutIfConditionIsMet() {
        l.bayaMargins = UIEdgeInsets(top: 3, left: 5, bottom: 4, right: 6)
        var layout = l.layoutIf {
            true
        }
        layout.startLayout(with: layoutRect)
        XCTAssertEqual(
            l.frame,
            CGRect(
                x: layoutRect.minX + 5,
                y: layoutRect.minY + 3,
                width: 60,
                height: 60))
    }

    func testLayoutIfConditionIsNotMet() {
        l.bayaMargins = UIEdgeInsets(top: 3, left: 5, bottom: 4, right: 6)
        var layout = l.layoutIf {
            false
        }
        layout.startLayout(with: layoutRect)
        XCTAssertEqual(
            l.frame,
            CGRect(
                x: 0,
                y: 0,
                width: 0,
                height: 0))
    }
}

//
// Copyright (c) 2017 wag it GmbH.
// License: MIT
//

import Foundation
import XCTest
@testable import Baya

class BayaScrollTests: XCTestCase {
    var content: TestLayoutable!
    var container: TestScrollLayoutContainer!
    let layoutRect = CGRect(x: 3, y: 4, width: 300, height: 400)

    override func setUp() {
        super.setUp()
        content = TestLayoutable()
        content.m(1, 2, 3, 4)
        container = TestScrollLayoutContainer()
    }

    override func tearDown() {
        super.tearDown()
        content = nil
        container = nil
    }

    func testSmallTestContentMeasuresCorrectly() {
        content = TestLayoutable(sideLength: 20)
        var layout = content.layoutScrollContent(container: container)
        let measure = layout.sizeThatFits(layoutRect.size)

        XCTAssertEqual(
            measure,
            CGSize(
                width: content.sideLength + content.horizontalMargins,
                height: content.sideLength + content.verticalMargins),
            "size does not match")
    }

    func testLargeTestContentMeasureIsLimitedByFrameSize() {
        content = TestLayoutable(sideLength: 1345)
        var layout = content.layoutScrollContent(container: container)
        let measure = layout.sizeThatFits(layoutRect.size)

        XCTAssertEqual(
            measure,
            CGSize(
                width: layoutRect.width,
                height: layoutRect.height),
            "size does not match")
    }

    
}
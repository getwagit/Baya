//
// Copyright (c) 2017 wag it GmbH.
// License: MIT
//

import Foundation
import Baya

class TestLayoutable: BayaLayoutable {
    var frame = CGRect()
    var layoutMargins = UIEdgeInsets.zero

    func sizeThatFits(_ size: CGSize) -> CGSize {
        return size
    }

    func layoutWith(frame: CGRect) {
        self.frame = frame
    }
}

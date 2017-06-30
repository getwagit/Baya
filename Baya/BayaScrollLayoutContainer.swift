//
// Copyright (c) 2016-2017 wag it GmbH.
// License: MIT
//

import Foundation
import UIKit

/**
    Implement this protocol for the scroll layout container.
 */
public protocol BayaScrollLayoutContainer: class, BayaLayoutable {
    var contentSize: CGSize { get set }
    func layoutWith(frame: CGRect) -> ()
}

extension UIScrollView: BayaScrollLayoutContainer {}

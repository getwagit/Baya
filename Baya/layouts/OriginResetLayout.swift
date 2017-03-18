//
// Copyright (c) 2016-2017 wag it GmbH.
// License: MIT
//

import Foundation
import Oak

/**
    Sets the origin of a given element to x: 0, y: 0. Handy when laying out views in deeper view hierarchies.
*/
struct OriginResetLayout: Layout {
    var layoutMargins: UIEdgeInsets
    var frame: CGRect

    private var element: Layoutable

    init(
        element: Layoutable,
        layoutMargins: UIEdgeInsets = UIEdgeInsets.zero) {
        self.element = element
        self.layoutMargins = layoutMargins
        self.frame = CGRect()
    }

    mutating func layoutWith(frame: CGRect) {
        self.frame = CGRect(origin: CGPoint(), size: frame.size)
        element.layoutWith(frame: self.frame)
    }

    func sizeThatFits(_ size: CGSize) -> CGSize {
        let fit = self.sizeThatFitsWithMargins(of: element, size: size)
        return self.addMargins(size: fit, element: self)
    }
}

/**
    Reset origin shortcut
*/
extension Layoutable {
    func resetOrigin() -> Layout {
        return OriginResetLayout(element: self)
    }
}

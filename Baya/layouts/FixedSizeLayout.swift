//
//  Created by Joachim Fröstl on 11.11.16.
//  Added extension by Markus Riegel on 12.07.2017.
//  Copyright © 2016-2017 wag it GmbH. All rights reserved.
//

import Foundation
import Oak

struct FixedSizeLayout: Layout {
    var layoutMargins: UIEdgeInsets
    var frame: CGRect

    private var element: Layoutable
    private var fixedWidth: CGFloat?
    private var fixedHeight: CGFloat?

    init(
            element: Layoutable,
            width: CGFloat?,
            height: CGFloat?,
            layoutMargins: UIEdgeInsets = UIEdgeInsets.zero) {
        self.fixedWidth = width
        self.fixedHeight = height
        self.element = element
        self.layoutMargins = layoutMargins
        self.frame = CGRect()
    }

    mutating func layoutWith(frame: CGRect) {
        self.frame = frame
        element.layoutWith(frame: frame)
    }

    func sizeThatFits(_ size: CGSize) -> CGSize {
        let fit = self.sizeThatFitsWithMargins(of: element, size: size)
        return CGSize(
            width: fixedWidth ?? (fit.width + horizontalMargins(of: element)),
            height: fixedHeight ?? (fit.height + verticalMargins(of: element)))
    }
}

// MARK: Fixed size shortcut

extension Layoutable {
    func fixedSize(width: CGFloat?, height: CGFloat?) -> Layoutable {
        return FixedSizeLayout(element: self, width: width, height: height)
    }
}

//
// Created by Markus Riegel on 18.03.17.
// Copyright (c) 2017 wag it GmbH. All rights reserved.
//

import Foundation
import UIKit

public extension Array where Element: BayaLayoutable {
    /**
        Distributes the available size evenly.
    */
    func layoutEqualSegments(
        orientation: BayaLayoutOptions.Orientation,
        gutter: CGFloat = 0,
        layoutMargins: UIEdgeInsets = UIEdgeInsets.zero)
            -> BayaEqualSegmentsLayout {
        return BayaEqualSegmentsLayout(
            elements: self,
            orientation: orientation,
            gutter: gutter,
            layoutMargins: layoutMargins)
    }

    /**
        Groups the layoutables together.
    */
    func layoutFrame(layoutMargins: UIEdgeInsets = UIEdgeInsets.zero) -> BayaFrameLayout {
        return BayaFrameLayout(elements: self, layoutMargins: layoutMargins)
    }
}

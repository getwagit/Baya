//
// Created by Markus Riegel on 18.03.17.
// Copyright (c) 2017 wag it GmbH. All rights reserved.
//

import Foundation

public struct Baya {
    /**
        Distributes the available size evenly.
    */
    func equalSegments(
        elements: [BayaLayoutable],
        orientation: BayaLayoutOptions.Orientation,
        gutter: CGFloat = 0,
        layoutMargins: UIEdgeInsets = UIEdgeInsets.zero)
            -> BayaEqualSegmentsLayout {
        return BayaEqualSegmentsLayout(
            elements: elements,
            orientation: orientation,
            gutter: gutter,
            layoutMargins: layoutMargins)
    }
}

public extension Array where Element: BayaLayoutable {
    /**
        Distributes the available size evenly.
    */
    func equalSegments(
        orientation: BayaLayoutOptions.Orientation,
        gutter: CGFloat = 0,
        layoutMargins: UIEdgeInsets = UIEdgeInsets.zero)
            -> BayaEqualSegmentsLayout {
        return BayaEqualSegmentsLayout(
            elements: elements,
            orientation: orientation,
            gutter: gutter,
            layoutMargins: layoutMargins)
    }
}
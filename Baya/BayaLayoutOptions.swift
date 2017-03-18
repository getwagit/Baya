//
// Copyright (c) 2016-2017 wag it GmbH.
// License: MIT
//

import Foundation

/**
    Collection of layout specific options.
*/
public struct BayaLayoutOptions {
    enum Orientation {
        case horizontal
        case vertical
    }

    enum Direction {
        case normal
        case reversed
    }

    struct Gravity {
        enum Horizontal {
            case left
            case center
            case right
        }
        enum Vertical {
            case top
            case middle
            case bottom
        }
    }
}

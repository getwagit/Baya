//
// Copyright (c) 2016-2017 wag it GmbH.
// License: MIT
//

import Foundation

/**
    Collection of layout specific options.
*/
public struct BayaLayoutOptions {
    public enum Orientation {
        case horizontal
        case vertical
    }

    public enum Direction {
        case normal
        case reversed
    }

    public struct Gravity {
        public enum Horizontal {
            case left
            case center
            case right
        }
        public enum Vertical {
            case top
            case middle
            case bottom
        }
    }
}

//
// Created by Markus Riegel on 30.08.16.
// Copyright (c) 2016 wag it GmbH. All rights reserved.
//

import Foundation

/**
    Collection of layout specific options.
*/
struct LayoutOptions {

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

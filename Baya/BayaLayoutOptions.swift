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

    public enum Mode {
        case wrapContent
        case matchParent
    }

    public struct Modes {
        internal static let `default` = BayaLayoutOptions.Modes(width: .wrapContent, height: .wrapContent)
        let width: BayaLayoutOptions.Mode
        let height: BayaLayoutOptions.Mode

        public init(width: BayaLayoutOptions.Mode, height: BayaLayoutOptions.Mode) {
            self.width = width
            self.height = height
        }
    }
}

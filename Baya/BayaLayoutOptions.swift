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
            case centerX
            case right
        }
        public enum Vertical {
            case top
            case centerY
            case bottom
        }
    }

    public enum Mode {
        case wrapContent
        case matchParent
    }

    public struct Modes {
        internal static let `default` = BayaLayoutOptions.Modes(width: .wrapContent, height: .wrapContent)
        public let width: BayaLayoutOptions.Mode
        public let height: BayaLayoutOptions.Mode

        public init(width: BayaLayoutOptions.Mode, height: BayaLayoutOptions.Mode) {
            self.width = width
            self.height = height
        }
    }
}

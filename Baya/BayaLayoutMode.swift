//
// Created by Markus Riegel on 28.06.17.
// Copyright (c) 2017 wag it GmbH. All rights reserved.
//

import Foundation

public enum BayaLayoutMode {
    case wrapContent
    case matchParent
}

public struct BayaLayoutModes {
    let width: BayaLayoutMode
    let height: BayaLayoutMode
    
    public init(width: BayaLayoutMode, height: BayaLayoutMode) {
        self.width = width
        self.height = height
    }
}

internal let defaultLayoutModes = BayaLayoutModes(width: .wrapContent, height: .wrapContent)

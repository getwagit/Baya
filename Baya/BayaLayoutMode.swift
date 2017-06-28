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
    let width: BayaLayoutMode;
    let height: BayaLayoutMode;
}

internal let defaultLayoutModes = BayaLayoutModes(width: .wrapContent, height: .wrapContent)
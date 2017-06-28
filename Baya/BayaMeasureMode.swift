//
// Created by Markus Riegel on 28.06.17.
// Copyright (c) 2017 wag it GmbH. All rights reserved.
//

import Foundation

public enum MeasureMode {
    case wrapContent
    case matchParent
}

public struct BayaMeasureModes {
    let width: MeasureMode;
    let height: MeasureMode;
}

internal let defaultMeasureModes = BayaMeasureModes(width: .wrapContent, height: .wrapContent)
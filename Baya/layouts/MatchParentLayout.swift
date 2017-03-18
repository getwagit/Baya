//
//  Created by Joachim Fröstl on 24.10.16.
//  Copyright © 2016 wag it GmbH. All rights reserved.
//

import Foundation
import UIKit

/**
    Lays the wrapped element out so it matches its parent's size.
 */
struct MatchParentLayout: Layout {
    
    var layoutMargins: UIEdgeInsets
    var frame: CGRect
    
    private var element: Layoutable
    private let matchParent: (width: Bool, height: Bool)
    
    init(
            element: Layoutable,
            matchParent: (width: Bool, height: Bool),
            layoutMargins: UIEdgeInsets = UIEdgeInsets.zero) {
        self.element = element
        self.matchParent = matchParent
        self.layoutMargins = layoutMargins
        self.frame = CGRect()
    }
    
    mutating func layoutWith(frame: CGRect) {
        self.frame = frame
        let size = sizeThatFitsWithMargins(of: element, size: frame.size)
        
        element.layoutWith(frame: CGRect(
            x: frame.minX + element.layoutMargins.left,
            y: frame.minY + element.layoutMargins.top,
            width: matchParent.width ? frame.width - self.horizontalMargins(of: element) : size.width,
            height: matchParent.height ? frame.height - self.verticalMargins(of: element) : size.height))
    }
    
    func sizeThatFits(_ size: CGSize) -> CGSize {
        if matchParent.width && matchParent.height {
            return size
        }
        let fit = sizeThatFitsWithMargins(of: element, size: size)
        return CGSize(
            width: matchParent.width ? size.width :
                fit.width + element.layoutMargins.left + element.layoutMargins.right,
            height: matchParent.height ? size.height :
                fit.height + element.layoutMargins.top + element.layoutMargins.bottom)
    }
}


// MARK: Match Parent Shortcuts

extension Layoutable {
    func matchParentWidth() -> Layoutable {
        return matchParent(width: true, height: false)
    }

    func matchParentHeight() -> Layoutable {
        return matchParent(width: false, height: true)
    }

    func matchParent() -> Layoutable {
        return matchParent(width: true, height: true)
    }

    func matchParent(width: Bool, height: Bool) -> Layoutable {
        return MatchParentLayout(
            element: self,
            matchParent: (width: width, height: height))
    }
}

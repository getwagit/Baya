//
// Copyright (c) 2016-2017 wag it GmbH.
// License: MIT
//

import Foundation
import UIKit

/**
    A Layout for a ScrollContainer and its content.
*/
struct ScrollLayout: Layout {
    
    var layoutMargins: UIEdgeInsets
    var frame: CGRect
    var orientation: LayoutOptions.Orientation
    
    private var container: ScrollLayoutContainer
    private var content: Layoutable
    
    init(
            content: Layoutable,
            container: ScrollLayoutContainer,
            orientation: LayoutOptions.Orientation = .vertical,
            layoutMargins: UIEdgeInsets = UIEdgeInsets.zero) {
        self.content = content
        self.container = container
        self.orientation = orientation
        self.layoutMargins = layoutMargins
        self.frame = CGRect()
    }
    
    mutating func layoutWith(frame: CGRect) {
        self.frame = frame
        
        let contentSize: CGSize = orientation == .horizontal ?
            content.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: frame.height)) :
            content.sizeThatFits(CGSize(width: frame.width, height: CGFloat.greatestFiniteMagnitude))
        
        // TODO: Needs to be tested: does this screw up the layout of a scrolled scroll container?
        content.layoutWith(frame: CGRect(
                origin: CGPoint(),
                size: contentSize))
        container.layoutWith(frame: CGRect(
                x: frame.origin.x + layoutMargins.left,
                y: frame.origin.y + layoutMargins.top,
                width: frame.width - layoutMargins.left - layoutMargins.right,
                height: frame.height - layoutMargins.top - layoutMargins.top))
        container.contentSize = contentSize
    }
    
    func sizeThatFits(_ size: CGSize) -> CGSize {
        // ScrollLayout always fits the given frame
        return size
    }
}

/**
    Implement this protocol for the scroll layout container.
 */
protocol ScrollLayoutContainer: class {
    var contentSize: CGSize { get set }
    func layoutWith(frame: CGRect) -> ()
}

// MARK: UIKit specific extensions

extension UIScrollView: ScrollLayoutContainer {}

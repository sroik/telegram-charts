//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

protocol Viewportable {
    var viewport: Viewport { get set }
}

class ViewportView: View, Viewportable {
    let contentView: UIView

    var contentFrame: CGRect {
        return CGRect(origin: contentOffset, size: contentSize)
    }

    var contentOffset: CGPoint {
        return CGPoint(x: -contentSize.width * viewport.min, y: 0)
    }

    var contentSize: CGSize {
        return CGSize(
            width: bounds.width / viewport.size,
            height: bounds.height
        )
    }

    var viewport: Viewport {
        didSet {
            adaptViewport()
        }
    }

    init(viewport: Viewport = .zeroToOne, content: UIView = UIView()) {
        self.viewport = viewport
        self.contentView = content
        super.init(frame: .screen)
        addSubview(contentView)
    }

    override func layoutSubviewsOnBoundsChange() {
        super.layoutSubviewsOnBoundsChange()
        adaptViewport()
    }

    func adaptViewport() {
        contentView.frame = contentFrame
    }
}

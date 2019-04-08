//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

protocol Viewportable {
    var viewport: Viewport { get set }
}

class ViewportView: View, Viewportable {
    let contentView: UIView
    let displayLink = DisplayLink(fps: 6)

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

    init(viewport: Viewport = .zeroToOne, content: UIView = View()) {
        self.viewport = viewport
        self.contentView = content
        super.init(frame: .screen)
        setup()
    }

    deinit {
        displayLink.stop()
    }

    override func layoutSubviewsOnBoundsChange() {
        super.layoutSubviewsOnBoundsChange()
        adaptViewport()
    }

    func adaptViewport() {
        contentView.frame = contentFrame
        displayLink.needsToDisplay = true
    }

    func display() {
        /* meant to be inherited */
    }

    private func setup() {
        addSubview(contentView)

        displayLink.start { [weak self] _ in
            self?.display()
        }
    }
}

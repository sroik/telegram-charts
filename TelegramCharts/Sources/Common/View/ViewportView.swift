//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

protocol Viewportable {
    var viewport: Viewport { get set }
}

class ViewportView: View, Viewportable {
    let contentView = View()
    var autolayouts: Bool
    let displayLink = DisplayLink(fps: 6)

    var viewport: Viewport {
        didSet {
            adaptViewport()
        }
    }

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

    init(viewport: Viewport = .zeroToOne, autolayouts: Bool = true) {
        self.viewport = viewport
        self.autolayouts = autolayouts
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
        if autolayouts {
            contentView.frame = contentFrame
        }

        displayLink.needsToDisplay = true
    }

    func display() {
        /* meant to be inherited */
    }

    private func setup() {
        addSubview(contentView)

        displayLink.start { [weak self] _ in
            guard let self = self, !self.bounds.isEmpty else {
                return
            }

            self.display()
        }
    }
}

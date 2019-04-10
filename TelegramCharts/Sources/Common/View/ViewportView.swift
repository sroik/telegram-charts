//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

class ViewportView: View, Viewportable {
    let contentView = View()
    var autolayouts: Bool
    let displayLink = DisplayLink(fps: 12)

    var viewport: Viewport {
        didSet {
            adaptViewport()
        }
    }

    var contentSize: CGSize {
        return CGSize(
            width: bounds.width / viewport.size,
            height: bounds.height
        )
    }

    var contentFrame: CGRect {
        return CGRect(
            x: -contentSize.width * viewport.min,
            size: contentSize
        )
    }

    var visibleRect: CGRect {
        return CGRect(
            x: contentSize.width * viewport.min,
            size: bounds.size
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
        guard autolayouts else {
            displayLink.needsToDisplay = true
            return
        }

        let isSizeChanged = !contentSize.isClose(to: contentView.bounds.size)
        contentView.frame = contentFrame
        displayLink.needsToDisplay = true

        if isSizeChanged {
            adaptViewportSize()
        }
    }

    func adaptViewportSize() {
        /* meant to be inherited */
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

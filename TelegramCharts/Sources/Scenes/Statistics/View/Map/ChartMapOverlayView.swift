//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

final class ChartMapOverlayView: View {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    override func layoutSubviewsOnBoundsChange() {
        super.layoutSubviewsOnBoundsChange()
        workspace.frame = bounds
        layoutViewport(animated: false)
    }

    override func themeUp() {
        super.themeUp()
        [leftSpaceView, rightSpaceView].forEach { view in
            view.backgroundColor = theme.color.mapDim
        }
    }

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return knob(at: point) != .none || bounds.contains(point)
    }

    func set(viewport: Viewport, animated: Bool, duration: TimeInterval = .defaultDuration) {
        if !self.viewport.isClose(to: viewport) {
            self.viewport = viewport
            layoutViewport(animated: animated, duration: duration)
        }
    }

    func layoutViewport(animated: Bool, duration: TimeInterval = .defaultDuration) {
        let animation = {
            self.leftSpaceView.frame = self.leftSpaceFrame
            self.rightSpaceView.frame = self.rightSpaceFrame
            self.viewportView.frame = self.viewportFrame
            self.viewportView.layoutIfNeeded()
        }

        UIView.run(
            animation: animation,
            animated: animated,
            duration: duration,
            options: .curveEaseInOut
        )
    }

    func knob(at point: CGPoint) -> ChartMapViewportView.Knob {
        let viewportPoint = convert(point, to: viewportView)
        return viewportView.knob(at: viewportPoint)
    }

    private func setup() {
        leftSpaceView.isUserInteractionEnabled = false
        rightSpaceView.isUserInteractionEnabled = false

        workspace.addSubviews(leftSpaceView, rightSpaceView)
        workspace.layer.cornerRadius = theme.state.cornerRadius
        workspace.layer.masksToBounds = true
        addSubviews(workspace, viewportView)
    }

    private var rightSpaceFrame: CGRect {
        let offset = viewportFrame.maxX - viewportView.knobWidth
        return bounds.remainder(at: offset, from: .minXEdge)
    }

    private var leftSpaceFrame: CGRect {
        let offset = viewportFrame.minX + viewportView.knobWidth
        return bounds.slice(at: offset, from: .minXEdge)
    }

    private var viewportFrame: CGRect {
        return CGRect(
            x: bounds.width * viewport.min,
            y: -viewportView.lineWidth,
            width: bounds.width * viewport.max - bounds.width * viewport.min,
            height: bounds.height + viewportView.lineWidth * 2
        )
    }

    private(set) var viewport: Viewport = .zeroToOne
    private let workspace = UIView()
    private let viewportView = ChartMapViewportView(frame: .screen)
    private let leftSpaceView = UIView()
    private let rightSpaceView = UIView()
}

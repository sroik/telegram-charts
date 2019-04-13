//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

final class ChartMapOverlayView: View {
    var viewport: Viewport = Range(min: 0.9, max: 1.0) {
        didSet {
            layoutViewport()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    override func layoutSubviewsOnBoundsChange() {
        super.layoutSubviewsOnBoundsChange()
        layoutViewport()
    }

    override func themeUp() {
        super.themeUp()
        layoutViewport()
        [leftSpaceView, rightSpaceView].forEach { view in
            view.backgroundColor = theme.color.mapDim
        }
    }

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return knob(at: point) != .none || bounds.contains(point)
    }

    func layoutViewport() {
        workspace.frame = bounds

        viewportView.frame = CGRect(
            x: bounds.width * viewport.min,
            y: -viewportView.lineWidth,
            width: bounds.width * viewport.max - bounds.width * viewport.min,
            height: bounds.height + viewportView.lineWidth * 2
        )

        leftSpaceView.frame = CGRect(
            x: 0, y: 0,
            width: viewportView.frame.minX + viewportView.knobWidth,
            height: bounds.height
        )

        rightSpaceView.frame = CGRect(
            x: viewportView.frame.maxX - viewportView.knobWidth, y: 0,
            width: bounds.width - viewportView.frame.maxX + viewportView.knobWidth,
            height: bounds.height
        )
    }

    private func setup() {
        leftSpaceView.isUserInteractionEnabled = false
        rightSpaceView.isUserInteractionEnabled = false

        workspace.addSubviews(leftSpaceView, rightSpaceView)
        workspace.layer.cornerRadius = theme.state.cornerRadius
        workspace.layer.masksToBounds = true
        addSubviews(workspace, viewportView)
    }

    func knob(at point: CGPoint) -> ChartMapViewportView.Knob {
        let viewportPoint = convert(point, to: viewportView)
        return viewportView.knob(at: viewportPoint)
    }

    private let workspace = UIView()
    private let viewportView = ChartMapViewportView(frame: .screen)
    private let leftSpaceView = UIView()
    private let rightSpaceView = UIView()
}

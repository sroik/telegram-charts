//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

protocol ChartMapOverlayViewDelegate: AnyObject {
    func mapView(_ view: ChartMapOverlayView, didChageViewportTo viewport: Range<CGFloat>)
}

final class ChartMapOverlayView: View {
    weak var delegate: ChartMapOverlayViewDelegate?

    /*
     I don't know the logic of it's size,
     so I'll leave this hardcoded number for now
     */
    var minSize: CGFloat = 0.075

    var viewport: Range<CGFloat> = Range(min: 0.85, max: 1.0) {
        didSet {
            layoutViewport()
        }
    }

    var selectedKnob: ChartMapViewportView.Knob {
        return viewportView.selectedKnob
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layoutViewport()
    }

    override func themeUp() {
        super.themeUp()
        layoutViewport()
        [leftSpaceView, rightSpaceView].forEach { view in
            view.backgroundColor = theme.color.background.withAlphaComponent(0.5)
        }
    }

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return knob(at: point) != .none
    }

    private func setup() {
        workspace.addSubviews(leftSpaceView, rightSpaceView)
        workspace.layer.cornerRadius = 6
        workspace.layer.masksToBounds = true

        addSubviews(workspace, viewportView)
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(onPan))
        panRecognizer.delaysTouchesBegan = false
        panRecognizer.cancelsTouchesInView = false
        addGestureRecognizer(panRecognizer)
    }

    private func layoutViewport() {
        workspace.frame = bounds

        viewportView.frame = CGRect(
            x: bounds.width * viewport.min,
            y: -viewportView.lineWidth,
            width: bounds.width * viewport.max - bounds.width * viewport.min,
            height: bounds.height + viewportView.lineWidth * 2
        )

        leftSpaceView.frame = CGRect(
            x: 0,
            y: 0,
            width: viewportView.frame.minX + viewportView.knobWidth,
            height: bounds.height
        )

        rightSpaceView.frame = CGRect(
            x: viewportView.frame.maxX - viewportView.knobWidth,
            y: 0,
            width: bounds.width - viewportView.frame.maxX + viewportView.knobWidth,
            height: bounds.height
        )
    }

    private func moveViewport(by delta: CGFloat) {
        let movedViewport: Range<CGFloat>
        switch viewportView.selectedKnob {
        case .left:
            movedViewport = Range(
                min: max(0, viewport.min + delta),
                max: viewport.max
            )
        case .right:
            movedViewport = Range(
                min: viewport.min,
                max: min(1, viewport.max + delta)
            )
        case .mid:
            let halfSize = viewport.size / 2
            movedViewport = Range(
                mid: (viewport.mid + delta).clamped(from: halfSize, to: 1 - halfSize),
                size: viewport.size
            )
        case .none:
            return
        }

        guard movedViewport.size > minSize else {
            return
        }

        viewport = movedViewport
        delegate?.mapView(self, didChageViewportTo: viewport)
    }

    @objc private func onPan(_ recognizer: UIPanGestureRecognizer) {
        guard !bounds.isEmpty, recognizer.state == .changed else {
            return
        }

        let translation = recognizer.translation(in: self).x
        let delta = translation / bounds.width
        moveViewport(by: delta)
        recognizer.setTranslation(.zero, in: self)
    }

    private func knob(at point: CGPoint) -> ChartMapViewportView.Knob {
        let viewportPoint = convert(point, to: viewportView)
        return viewportView.knob(at: viewportPoint)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if let point = touches.first?.location(in: self) {
            viewportView.selectedKnob = knob(at: point)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        viewportView.selectedKnob = .none
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        viewportView.selectedKnob = .none
    }

    private let workspace = UIView()
    private let viewportView = ChartMapViewportView(frame: .screen)
    private let leftSpaceView = UIView()
    private let rightSpaceView = UIView()
}

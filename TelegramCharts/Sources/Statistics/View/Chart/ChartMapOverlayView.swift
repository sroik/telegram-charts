//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

protocol ChartMapOverlayViewDelegate: AnyObject {
    func mapView(_ view: ChartMapOverlayView, didChageViewportTo viewport: Range<CGFloat>)
}

final class ChartMapOverlayView: View {
    weak var delegate: ChartMapOverlayViewDelegate?

    var viewport: Range<CGFloat> = Range(min: 0, max: 1) {
        didSet {
            layoutViewport()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layoutViewport()
    }

    private func setup() {
        addSubviews(viewportView, leftSpaceView, rightSpaceView)

        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(onPan))
        panRecognizer.delaysTouchesBegan = false
        panRecognizer.cancelsTouchesInView = false
        addGestureRecognizer(panRecognizer)
    }

    private func layoutViewport() {
        viewportView.frame = CGRect(
            x: bounds.width * viewport.min,
            y: -viewportView.lineWidth,
            width: bounds.width * viewport.max - bounds.width * viewport.min,
            height: bounds.height + viewportView.lineWidth * 2
        )

        leftSpaceView.frame = CGRect(
            x: 0,
            y: 0,
            width: viewportView.frame.minX,
            height: bounds.height
        )

        rightSpaceView.frame = CGRect(
            x: viewportView.frame.maxX,
            y: 0,
            width: bounds.width - viewportView.frame.maxX,
            height: bounds.height
        )
    }

    private func moveViewport(by delta: CGFloat) {
        switch viewportView.selectedKnob {
        case .left:
            viewport = Range(
                min: max(0, viewport.min + delta),
                max: viewport.max
            )
        case .right:
            viewport = Range(
                min: viewport.min,
                max: min(1, viewport.max + delta)
            )
        case .mid:
            let halfSize = viewport.size / 2
            viewport = Range(
                mid: (viewport.mid + delta).clamped(from: halfSize, to: 1 - halfSize),
                size: viewport.size
            )
        case .none:
            return
        }

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

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if let point = touches.first?.location(in: self) {
            viewportView.selectedKnob = viewportView.knob(at: point)
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

    override func themeUp() {
        super.themeUp()
        [leftSpaceView, rightSpaceView].forEach { view in
            view.backgroundColor = theme.color.background.withAlphaComponent(0.5)
        }
    }

    private let viewportView = ChartMapViewportView(frame: .screen)
    private let leftSpaceView = UIView()
    private let rightSpaceView = UIView()
}

//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

protocol ChartMapOverlayViewDelegate: AnyObject {
    func mapView(_ view: ChartMapOverlayView, didChageViewportTo viewport: Viewport)
    func mapViewDidLongPress(_ view: ChartMapOverlayView)
}

final class ChartMapOverlayView: View {
    weak var delegate: ChartMapOverlayViewDelegate?
    var minSize: CGFloat = 0
    var maxSize: CGFloat = 1.0

    var viewport: Viewport = Range(min: 0.9, max: 1.0) {
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

    private func setup() {
        leftSpaceView.isUserInteractionEnabled = false
        rightSpaceView.isUserInteractionEnabled = false

        workspace.addSubviews(leftSpaceView, rightSpaceView)
        workspace.layer.cornerRadius = 6
        workspace.layer.masksToBounds = true
        addSubviews(workspace, viewportView)

        [panRecognizer, pressRecognizer, tapRecognizer].forEach { recognizer in
            recognizer.cancelsTouchesInView = false
            recognizer.delaysTouchesEnded = false
            recognizer.delegate = self
            addGestureRecognizer(recognizer)
        }
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

    private func moveViewport(by delta: CGFloat) {
        let movedViewport: Viewport
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

        guard movedViewport.size > minSize, movedViewport.size < maxSize else {
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

    @objc private func onPress(_ recognizer: UILongPressGestureRecognizer) {
        delegate?.mapViewDidLongPress(self)
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

    private lazy var tapRecognizer = UITapGestureRecognizer(
        target: self,
        action: #selector(onPress)
    )

    private lazy var panRecognizer = UIPanGestureRecognizer(
        target: self,
        action: #selector(onPan)
    )

    private lazy var pressRecognizer = UILongPressGestureRecognizer(
        target: self,
        action: #selector(onPress)
    )

    private let workspace = UIView()
    private let viewportView = ChartMapViewportView(frame: .screen)
    private let leftSpaceView = UIView()
    private let rightSpaceView = UIView()
}

extension ChartMapOverlayView: UIGestureRecognizerDelegate {
    override func gestureRecognizerShouldBegin(_ recognizer: UIGestureRecognizer) -> Bool {
        guard recognizer == panRecognizer else {
            return true
        }

        let velocity = panRecognizer.velocity(in: self)
        return abs(velocity.x) > abs(velocity.y)
    }

    func gestureRecognizer(
        _ recognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith other: UIGestureRecognizer
    ) -> Bool {
        if recognizer == panRecognizer, other == pressRecognizer {
            return true
        }

        if recognizer == pressRecognizer, other == panRecognizer {
            return true
        }

        return false
    }
}

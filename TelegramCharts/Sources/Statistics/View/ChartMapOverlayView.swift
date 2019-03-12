//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

protocol ChartMapOverlayViewDelegate: AnyObject {
    func mapView(_ view: ChartMapOverlayView, didChageRange range: Range<CGFloat>)
}

final class ChartMapOverlayView: View {
    weak var delegate: ChartMapOverlayViewDelegate?

    var range: Range<CGFloat> = Range(min: 0.8, max: 1.0) {
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
            x: bounds.width * range.min,
            y: -viewportView.lineWidth,
            width: bounds.width * range.max - bounds.width * range.min,
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
        let movedMin = range.min + delta
        let movedMax = range.max + delta
        
        switch viewportView.selectedKnob {
        case .left where movedMin > 0:
            range = Range(
                min: movedMin,
                max: range.max
            )
        case .right where movedMax < 1:
            range = Range(
                min: range.min,
                max: movedMax
            )
        case .mid where movedMin > 0 && movedMax < 1:
            range = Range(
                min: movedMin,
                max: movedMax
            )
        default:
            break
        }
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

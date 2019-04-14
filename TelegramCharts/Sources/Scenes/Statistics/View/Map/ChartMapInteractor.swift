//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

protocol ChartMapInteractorDelegate: AnyObject {
    func interactor(_ interactor: ChartMapInteractor, didChageViewportTo viewport: Viewport)
    func interactorDidLongPress(_ view: ChartMapInteractor)
}

class ChartMapInteractor: NSObject {
    weak var delegate: ChartMapInteractorDelegate?
    var selectedKnob: ChartMapViewportView.Knob = .none
    var minSize: CGFloat = 0
    var maxSize: CGFloat = 1
    var minShift: CGFloat = 0

    var pinnable: Bool {
        return minShift > .ulpOfOne
    }

    var viewport: Viewport {
        return overlay?.viewport ?? .zeroToOne
    }

    func register(in overlay: ChartMapOverlayView) {
        self.overlay = overlay
        pressRecognizer.minimumPressDuration = 0
        [panRecognizer, pressRecognizer, tapRecognizer].forEach { recognizer in
            recognizer.cancelsTouchesInView = false
            recognizer.delaysTouchesEnded = false
            recognizer.delegate = self
            overlay.addGestureRecognizer(recognizer)
        }
    }

    @discardableResult
    func shiftViewport(by delta: CGFloat, animated: Bool) -> Bool {
        var shifted: Viewport
        switch selectedKnob {
        case .mid:
            let halfSize = viewport.size / 2
            let mid = (viewport.mid + delta).clamped(from: halfSize, to: 1 - halfSize)
            shifted = Range(mid: mid, size: viewport.size)
        case .left:
            let min = (viewport.min + delta).clamped(from: 0, to: viewport.max - minSize)
            shifted = Range(min: min, max: viewport.max)
        case .right:
            let max = (viewport.max + delta).clamped(from: viewport.min + minSize, to: 1)
            shifted = Range(min: viewport.min, max: max)
        case .none:
            return false
        }

        guard !viewport.isClose(to: shifted) else {
            return false
        }

        overlay?.set(viewport: shifted, animated: animated)
        delegate?.interactor(self, didChageViewportTo: shifted)
        return true
    }

    @objc func onPan(_ recognizer: UIPanGestureRecognizer) {
        guard let overlay = overlay, recognizer.state == .changed else {
            shiftAccumulator = 0
            return
        }

        let translation = recognizer.translation(in: overlay).x
        let delta = translation / overlay.bounds.width
        recognizer.setTranslation(.zero, in: overlay)
        shiftAccumulator += delta

        guard pinnable else {
            shiftViewport(by: delta, animated: false)
            return
        }

        guard abs(shiftAccumulator) > minShift * 0.5 else {
            return
        }

        let shift = delta.floatingSign * minShift
        let shifted = shiftViewport(by: shift, animated: true)
        shiftAccumulator = shifted ? shiftAccumulator - shift : 0
    }

    @objc func onTap(_ recognizer: UITapGestureRecognizer) {
        delegate?.interactorDidLongPress(self)
    }

    @objc func onPress(_ recognizer: UILongPressGestureRecognizer) {
        switch recognizer.state {
        case .began:
            let point = recognizer.location(in: overlay)
            selectedKnob = overlay?.knob(at: point) ?? .none
            delegate?.interactorDidLongPress(self)
        case .ended, .cancelled, .failed:
            selectedKnob = .none
        case .possible, .changed:
            break
        }
    }

    private(set) lazy var tapRecognizer = UITapGestureRecognizer(
        target: self,
        action: #selector(onTap)
    )

    private(set) lazy var panRecognizer = UIPanGestureRecognizer(
        target: self,
        action: #selector(onPan)
    )

    private(set) lazy var pressRecognizer = UILongPressGestureRecognizer(
        target: self,
        action: #selector(onPress)
    )

    private var shiftAccumulator: CGFloat = 0
    private(set) var overlay: ChartMapOverlayView?
}

extension ChartMapInteractor: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ recognizer: UIGestureRecognizer) -> Bool {
        guard recognizer == panRecognizer else {
            return true
        }

        let velocity = panRecognizer.velocity(in: overlay)
        return abs(velocity.x) > abs(velocity.y)
    }

    func gestureRecognizer(
        _ recognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith other: UIGestureRecognizer
    ) -> Bool {
        if recognizer == pressRecognizer {
            return true
        }

        if recognizer == panRecognizer, other == pressRecognizer {
            return true
        }

        return false
    }
}

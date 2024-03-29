//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

final class DisplayLink {
    var callback: DisplayLinkListener.Callback? {
        get {
            return listener.callback
        }
        set {
            listener.callback = newValue
        }
    }

    var needsToDisplay: Bool {
        get {
            return listener.needsToDisplay
        }
        set {
            listener.needsToDisplay = newValue
        }
    }

    var isPaused: Bool {
        get {
            return displayLink.isPaused
        }
        set {
            displayLink.isPaused = newValue
        }
    }

    var fps: Int {
        didSet {
            displayLink.preferredFramesPerSecond = fps
        }
    }

    init(fps: Int, callback: DisplayLinkListener.Callback? = nil) {
        self.fps = fps
        self.callback = callback
    }

    deinit {
        stop()
    }

    func start(with callback: @escaping DisplayLinkListener.Callback) {
        self.callback = callback
        start()
    }

    func start() {
        displayLink.preferredFramesPerSecond = fps
        displayLink.add(to: .main, forMode: .common)
    }

    func stop() {
        displayLink.invalidate()
    }

    private lazy var listener = DisplayLinkListener()
    private lazy var displayLink = CADisplayLink(
        target: listener,
        selector: #selector(DisplayLinkListener.displayLinkFired(_:))
    )
}

final class DisplayLinkListener {
    typealias Callback = (_ timestamp: TimeInterval) -> Void

    var needsToDisplay: Bool = true
    var callback: Callback?

    init(callback: Callback? = nil) {
        self.callback = callback
    }

    @objc func displayLinkFired(_ displayLink: CADisplayLink) {
        if needsToDisplay {
            callback?(displayLink.timestamp)
            needsToDisplay = false
        }
    }
}

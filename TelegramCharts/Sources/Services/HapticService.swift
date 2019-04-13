//
//  Copyright © 2018 sroik. All rights reserved.
//

import AudioToolbox
import UIKit

final class HapticService {
    enum Event {
        case selection
        case impact(style: UIImpactFeedbackGenerator.FeedbackStyle)
        case notification(UINotificationFeedbackGenerator.FeedbackType)
    }

    init() {
        selectionGenerator.prepare()
        notificationGenerator.prepare()
    }

    func feedback(with event: Event) {
        switch event {
        case .notification(.error) where !UIDevice.isHapticAvailable:
            vibrate()

        case let .notification(type):
            notificationGenerator.notificationOccurred(type)
            notificationGenerator.prepare()

        case .selection:
            selectionGenerator.selectionChanged()
            selectionGenerator.prepare()

        case let .impact(style):
            let generator = UIImpactFeedbackGenerator(style: style)
            generator.impactOccurred()
        }
    }

    func vibrate() {
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }

    private let notificationGenerator = UINotificationFeedbackGenerator()
    private let selectionGenerator = UISelectionFeedbackGenerator()
}

private extension UIDevice {
    static let isHapticAvailable = current.isHapticAvailable

    var isHapticAvailable: Bool {
        guard let level = value(forKey: "_feedbackSupportLevel") as? Int else {
            return false
        }

        return level > 1
    }
}

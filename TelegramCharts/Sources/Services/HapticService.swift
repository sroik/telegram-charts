//
//  Copyright © 2018 sroik. All rights reserved.
//

import AudioToolbox
import UIKit

final class HapticService {
    enum Event {
        case selection
        case notification(UINotificationFeedbackGenerator.FeedbackType)
    }

    static var isHapticAvailable: Bool {
        guard let level = UIDevice.current.value(forKey: "_feedbackSupportLevel") as? Int else {
            return false
        }

        return level > 1
    }

    static func feedback(with event: Event) {
        switch event {
        case .notification(.error) where !isHapticAvailable:
            vibrate()

        case let .notification(type):
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            generator.notificationOccurred(type)

        case .selection:
            let generator = UISelectionFeedbackGenerator()
            generator.prepare()
            generator.selectionChanged()
        }
    }

    static func vibrate() {
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
}

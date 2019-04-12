//
//  Copyright © 2019 sroik. All rights reserved.
//

import Foundation

enum Sound {
    case haptic(event: HapticService.Event)
}

protocol SoundService {
    func play(_ sound: Sound)
}

final class SystemSoundService: SoundService {
    func play(_ sound: Sound) {
        switch sound {
        case let .haptic(event):
            hapticService.feedback(with: event)
        }
    }

    private let hapticService = HapticService()
}

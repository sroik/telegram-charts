//
//  Copyright © 2019 sroik. All rights reserved.
//

import Foundation

enum Sound {
    case errorFeedback
    case selectionFeedback
}

protocol SoundService {
    func play(_ sound: Sound)
}

final class SystemSoundService: SoundService {
    func play(_ sound: Sound) {
        switch sound {
        case .errorFeedback:
            HapticService.feedback(with: .notification(.error))
        case .selectionFeedback:
            HapticService.feedback(with: .selection)
        }
    }
}

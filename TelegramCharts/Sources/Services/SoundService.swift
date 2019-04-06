//
//  Copyright © 2019 sroik. All rights reserved.
//

import Foundation

enum Sound {
    case errorFeedback
}

protocol SoundService {
    func play(_ sound: Sound)
}

final class SystemSoundService: SoundService {
    func play(_ sound: Sound) {
        switch sound {
        case .errorFeedback:
            HapticService.feedback(with: .notification(.error))
        }
    }
}

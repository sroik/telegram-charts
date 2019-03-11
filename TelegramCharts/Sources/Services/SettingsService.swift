//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

struct Settings {
    var theme: ThemeMode
}

protocol SettingsService {
    var settings: Settings { get }
    func tweak(_ block: (inout Settings) -> Void)
    func bind(with callback: @escaping (Settings) -> Void) -> Token
}

extension Settings {
    static let `default` = Settings(theme: .day)
}

final class InMemorySettingsService: SettingsService {
    var settings: Settings {
        return _settings.value
    }

    init(settings: Settings) {
        _settings = Property(value: settings)
    }

    func tweak(_ block: (inout Settings) -> Void) {
        synchronized(self) {
            var tweakedSettings = settings
            block(&tweakedSettings)
            _settings.value = tweakedSettings
        }
    }

    func bind(with callback: @escaping (Settings) -> Void) -> Token {
        return _settings.bind(on: .main, with: callback)
    }

    private let _settings: Property<Settings>
}

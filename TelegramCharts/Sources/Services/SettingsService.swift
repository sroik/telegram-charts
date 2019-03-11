//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

struct Settings: Hashable, Codable {
    var themeMode: ThemeMode
}

protocol SettingsService {
    var settings: Settings { get }
    func tweak(_ block: (inout Settings) -> Void)
}

extension Settings {
    static let `default` = Settings(themeMode: .day)
}

final class LocalSettingsService: SettingsService {
    var settings: Settings {
        return restore()
    }

    init(
        storage: UserDefaults = .standard,
        domain: String = "com.telegram_contest.settings",
        defaults: Settings = .default
    ) {
        self.domain = domain
        self.storage = storage
        self.defaults = defaults
    }

    func tweak(_ block: (inout Settings) -> Void) {
        synchronized(self) {
            var tweakedSettings = settings
            block(&tweakedSettings)
            backup(settings: tweakedSettings)
        }
    }

    private func restore() -> Settings {
        guard let data = storage.data(forKey: domain) else {
            return defaults
        }

        do {
            return try JSONDecoder().decode(Settings.self, from: data)
        } catch {
            assertionFailureWrapper("failed to encode settings")
            return defaults
        }
    }

    private func backup(settings: Settings) {
        do {
            let data = try JSONEncoder().encode(settings)
            storage.setValue(data, forKey: domain)
        } catch {
            assertionFailureWrapper("failed to encode settings")
        }
    }

    private let defaults: Settings
    private let storage: UserDefaults
    private let domain: String
}

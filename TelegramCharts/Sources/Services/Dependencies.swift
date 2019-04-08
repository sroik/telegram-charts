//
//  Copyright © 2019 sroik. All rights reserved.
//

import Foundation

final class Dependencies {
    let charts: ChartsService
    let settings: SettingsService
    let sounds: SoundService

    init(
        charts: ChartsService = BuiltinChartsService(directory: "charts"),
        settings: SettingsService = LocalSettingsService(),
        sounds: SoundService = SystemSoundService()
    ) {
        self.charts = charts
        self.settings = settings
        self.sounds = sounds
    }
}

protocol SettingsServiceContainer {
    var settings: SettingsService { get }
}

protocol ChartsServiceContainer {
    var charts: ChartsService { get }
}

protocol SoundServiceContainer {
    var sounds: SoundService { get }
}

extension Dependencies: SoundServiceContainer {}
extension Dependencies: SettingsServiceContainer {}
extension Dependencies: ChartsServiceContainer {}

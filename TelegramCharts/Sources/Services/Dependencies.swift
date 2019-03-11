//
//  Copyright © 2019 sroik. All rights reserved.
//

import Foundation

final class Dependencies {
    let charts: ChartsService
    let settings: SettingsService

    init(
        charts: ChartsService = BuiltinChartsService(file: "charts.json"),
        settings: SettingsService = LocalSettingsService()
    ) {
        self.charts = charts
        self.settings = settings
    }
}

protocol SettingsServiceContainer {
    var settings: SettingsService { get }
}

protocol ChartsServiceContainer {
    var charts: ChartsService { get }
}

extension Dependencies: SettingsServiceContainer {}
extension Dependencies: ChartsServiceContainer {}

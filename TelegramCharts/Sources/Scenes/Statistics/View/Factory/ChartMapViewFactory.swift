//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

struct ChartMapViewFactory {
    static func view(with chart: Chart, sounds: SoundService) -> ChartMapView {
        return ChartMapView(
            chartView: ChartViewFactory.timelineView(with: chart, isMap: true),
            sounds: sounds
        )
    }
}

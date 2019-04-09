//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

struct ChartMapViewFactory {
    static func view(with chart: Chart) -> ChartMapView {
        let chartView = ChartViewFactory.view(with: chart, isMap: true)
        return ChartMapView(chartView: chartView)
    }
}

//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

struct ChartMapViewFactory {
    static func view(with chart: Chart) -> ChartMapView {
        return ChartMapView(
            chartView: ChartViewFactory.view(with: chart, isMap: true)
        )
    }
}

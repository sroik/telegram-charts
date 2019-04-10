//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

struct ChartViewFactory {
    static func view(with chart: Chart, isMap: Bool = false) -> ChartView {
        switch chart.columnsType {
        case .bar where isMap:
            return RasterizedBarChartView(chart: chart)
        case .bar:
            #warning("fix")
//            return BarChartView(chart: chart)
            return lineChartView(with: chart, isMap: isMap)
        case .line, .area:
            return lineChartView(with: chart, isMap: isMap)
        case .timestamps:
            assertionFailureWrapper()
            return LineChartView(chart: chart)
        }
    }

    static func lineChartView(with chart: Chart, isMap: Bool) -> LineChartView {
        let view = chart.yScaled ?
            ComparingLineChartView(chart: chart) :
            LineChartView(chart: chart)

        view.set(lineWidth: isMap ? 1 : 2)
        return view
    }
}

//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

struct ChartViewFactory {
    static func view(with chart: Chart, isMap: Bool = false) -> ChartView {
        switch chart.columnsType {
        case .line:
            return lineChartView(with: chart, isMap: isMap)
        case .bar:
            return rasterizedBarChartView(with: chart, isMap: isMap)
        case .area:
            return PercentageLineChartView(chart: chart)
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

    static func rasterizedBarChartView(
        with chart: Chart,
        isMap: Bool
    ) -> RasterizedBarChartView {
        return RasterizedBarChartView(
            chart: chart,
            minViewportSize: isMap ? 1 : chart.minViewportSize,
            renderer: BarChartRenderer(chart: chart, inflatesFrames: isMap)
        )
    }
}

//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

struct ChartViewControllerLayout {
    var insets: UIEdgeInsets
    var hasMap: Bool
    var mapHeight: CGFloat
    var hasColumns: Bool
    var columnsHeight: CGFloat
    var periodHeight: CGFloat
    var chartHeight: CGFloat
}

extension ChartViewControllerLayout {
    init(chart: Chart) {
        self.init(
            insets: UIEdgeInsets(top: 0, left: 15, bottom: 15, right: 15),
            hasMap: true,
            mapHeight: 40,
            hasColumns: chart.drawableColumns.count > 1,
            columnsHeight: 0,
            periodHeight: 32,
            chartHeight: 408
        )
    }

    var actualMapHeight: CGFloat {
        return (hasMap ? mapHeight : 0)
    }

    var actualColumnsHeight: CGFloat {
        return (hasColumns ? columnsHeight : 0)
    }

    var contentHeight: CGFloat {
        return periodHeight + chartHeight + insets.vertical +
            actualMapHeight + actualColumnsHeight
    }

    func mapFrame(in rect: CGRect) -> CGRect {
        let mapInsets = UIEdgeInsets(bottom: hasMap ? actualColumnsHeight : 0)
        return rect
            .inset(by: insets)
            .inset(by: mapInsets)
            .slice(at: actualMapHeight, from: .maxYEdge)
    }

    func columnsFrame(in rect: CGRect) -> CGRect {
        return rect
            .inset(by: insets)
            .slice(at: actualColumnsHeight, from: .maxYEdge)
    }

    func periodFrame(in rect: CGRect) -> CGRect {
        return rect
            .inset(by: insets)
            .slice(at: periodHeight, from: .minYEdge)
    }

    func chartFrame(in rect: CGRect) -> CGRect {
        let periodMaxY = periodFrame(in: rect).maxY
        let mapMinY = mapFrame(in: rect).minY
        return CGRect(
            x: 0,
            y: periodMaxY,
            width: rect.width,
            height: mapMinY - periodMaxY - 10
        )
    }
}

//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

final class SnapshotChartView: View {
    init(chartView: ChartView) {
        self.chartView = chartView
        super.init(frame: .zero)
        setup()
    }

    override func layoutSubviewsOnBoundsChange() {
        super.layoutSubviewsOnBoundsChange()
        chartView.frame = bounds
        imageView.frame = bounds
        update(animated: false)
    }

    override func themeUp() {
        super.themeUp()
        chartView.theme = theme
        update(animated: false)
    }

    func update(animated: Bool) {
        guard !bounds.isEmpty else {
            return
        }

        let snapshot = chartView.snapshot
        imageView.set(image: snapshot, animated: animated)
    }

    private func setup() {
        addSubview(imageView)
    }

    private let imageView = UIImageView()
    private var chartView: ChartView
}

extension SnapshotChartView: ChartViewType {
    var chart: Chart {
        return chartView.chart
    }

    var contentSize: CGSize {
        return chartView.contentSize
    }

    var viewport: Viewport {
        get {
            return chartView.viewport
        }
        set {
            chartView.viewport = newValue
            update(animated: true)
        }
    }

    var selectedIndex: Int? {
        get {
            return chartView.selectedIndex
        }
        set {
            chartView.selectedIndex = newValue
        }
    }

    func enable(columns: [Column], animated: Bool) {
        chartView.enable(columns: columns, animated: false)
        update(animated: animated)
    }
}

//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

final class RasterizedBarChartView: ViewportView, ChartViewType {
    let chart: Chart
    var selectedIndex: Int?

    init(chart: Chart) {
        self.chart = chart
        self.renderer = BarChartRenderer(chart: chart)
        super.init(frame: .zero)
        setup()
    }

    override func themeUp() {
        super.themeUp()
        contentView.backgroundColor = theme.color.placeholder
    }

    override func adaptViewportSize() {
        super.adaptViewportSize()
        imageView.frame = contentView.bounds
        update(animated: false)
    }

    func enable(columns: [Column], animated: Bool) {
        enabledColumns = columns
        update(animated: true)
    }

    func update(animated: Bool) {
        guard !bounds.isEmpty else {
            return
        }

        renderer.render(columns: enabledColumns, size: contentSize) { [weak self] image in
            self?.imageView.set(image: image, animated: animated)
        }
    }

    private func setup() {
        imageView.layer.minificationFilter = .nearest
        imageView.layer.magnificationFilter = .nearest
        contentView.addSubview(imageView)
        enable(columns: chart.drawableColumns, animated: false)
    }

    private let renderer: BarChartRenderer
    private let imageView = UIImageView()
    private var enabledColumns: [Column] = []
}

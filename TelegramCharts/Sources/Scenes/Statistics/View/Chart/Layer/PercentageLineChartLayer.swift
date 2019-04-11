//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

final class PercentageLineChartLayer: Layer {
    convenience init(chart: Chart) {
        self.init(chartColumns: chart.drawableColumns)
    }

    init(chartColumns: [Column]) {
        self.columns = StackedColumn.columns(with: chartColumns)
        self.layers = chartColumns.map { CAShapeLayer(column: $0) }
        super.init()
        setup()
    }

    override init(layer: Any) {
        self.layers = []
        self.columns = []
        super.init(layer: layer)
    }

    required convenience init?(coder aDecoder: NSCoder) {
        self.init(chartColumns: [])
    }

    override func themeUp() {
        super.themeUp()
        backgroundColor = theme.color.placeholder.cgColor
    }

    override func layoutSublayersOnBoundsChange() {
        super.layoutSublayersOnBoundsChange()
        layers.forEach { $0.frame = bounds }
        draw(animated: false)
    }

    func enable(values: Set<String>, animated: Bool) {
        columns.transform { $1.enable(ids: values) }
        draw(animated: animated)
    }

    func draw(animated: Bool) {
        backgroundColor = UIColor.yellow.cgColor
        let spacing = bounds.width / CGFloat(columns.count)
        var paths: [CGPath] = []
    }

    private func setup() {
        isOpaque = true
        layers.forEach(addSublayer)
        disableActions()
        themeUp()
    }

    private let layers: [CALayer]
    private var columns: [StackedColumn]
}

private extension CAShapeLayer {
    convenience init(column: Column) {
        self.init()
        fillColor = column.cgColor
        strokeColor = nil
        disableActions()
    }
}

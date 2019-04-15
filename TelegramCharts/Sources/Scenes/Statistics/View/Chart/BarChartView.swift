//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

class BarChartView: ViewportView, TimelineChartViewType {
    typealias EnumerationBlock = (_ index: Int, _ layer: BarColumnLayer) -> Void

    var visibleInsets = UIEdgeInsets(right: -15, left: -15)
    var selectedIndex: Int?
    let chart: Chart
    let layout: GridLayout
    let layers: [BarColumnLayer]

    init(chart: Chart) {
        self.chart = chart
        self.layers = BarColumnLayer.layers(with: chart)
        self.layout = GridLayout(itemsNumber: layers.count)
        super.init()
        setup()
    }

    override func themeUp() {
        super.themeUp()
        contentView.backgroundColor = theme.color.placeholder
        layers.forEach { $0.theme = theme }
    }

    override func adaptViewport() {
        super.adaptViewport()
        layoutLayers()
    }

    func enable(columns: [String], animated: Bool) {
        layers.forEach { $0.enable(values: Set(columns)) }
        enabledColumns = chart.columns(with: columns)
        adaptRange(animated: animated)
    }

    func adaptRange(animated: Bool) {
        let maxRange = chart.range(of: enabledColumns)
        let range = chart.range(of: enabledColumns, in: viewport)
        let rangeScale = CGFloat(maxRange.size) / CGFloat(range.size)

        forEachVisibleLayer { index, layer in
            layer.set(
                maxValue: chart.percentage ? layer.stackedValue() : range.max,
                minHeight: rangeScale,
                animated: animated
            )
        }
    }

    func layoutLayers() {
        layers.enumerated().forEach { index, layer in
            guard isVisibleLayer(at: index) else {
                layer.removeFromSuperlayerIfNeeded()
                return
            }

            contentView.layer.addSublayerIfNeeded(layer)
            layer.frame = layerFrame(at: index)
            layer.draw(animated: false)
        }
    }

    func visibleLayersNumber() -> Int {
        return layers.indices.filter(isVisibleLayer).count
    }

    func forEachVisibleLayer(do block: EnumerationBlock) {
        layers.enumerated().forEach { index, layer in
            if isVisibleLayer(at: index) {
                block(index, layer)
            }
        }
    }

    private func isVisibleLayer(at index: Int) -> Bool {
        let frame = layerFrame(at: index)
        return visibleInsets.inset(visibleRect).intersects(frame)
    }

    private func layerFrame(at index: Int) -> CGRect {
        return layout.itemFrame(at: index, in: contentView.bounds).rounded()
    }

    private func setup() {
        enable(columns: chart.drawableColumns.ids, animated: false)
    }

    private var enabledColumns: [Column] = []
}

private extension BarColumnLayer {
    static func layers(with chart: Chart) -> [BarColumnLayer] {
        return StackedColumn.columns(with: chart.drawableColumns).map {
            BarColumnLayer(column: $0)
        }
    }
}

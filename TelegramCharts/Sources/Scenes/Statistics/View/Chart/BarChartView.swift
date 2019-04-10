//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

class BarChartView: ViewportView, ChartViewType {
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
    }

    override func adaptViewport() {
        super.adaptViewport()
        layoutLayers()
        adaptRange(animated: false)
    }

    func enable(columns: [Column], animated: Bool) {
        let columnsIds = Set(columns.map { $0.id })
        layers.forEach { $0.enable(values: columnsIds) }
        enabledColumns = columns
        adaptRange(animated: animated)
    }

    func adaptRange(animated: Bool) {
        let range = chart.adjustedRange(of: enabledColumns, in: viewport)
        forEachVisibleLayer { index, layer in
            layer.set(range: range, animated: animated)
        }
    }

    func layoutLayers() {
        layers.enumerated().forEach { index, layer in
            if isVisible(layer: layer, at: index) {
                contentView.layer.add(child: layer)
                layer.frame = layerFrame(at: index)
            } else {
                layer.dropFromParent()
            }
        }
    }

    func forEachVisibleLayer(do block: EnumerationBlock) {
        layers.enumerated().forEach { index, layer in
            if isVisible(layer: layer, at: index) {
                block(index, layer)
            }
        }
    }

    private func isVisible(layer: BarColumnLayer, at index: Int) -> Bool {
        let visibleFrame = visibleInsets.inset(visibleRect)
        let frame = layerFrame(at: index)
        return visibleFrame.intersects(layer.frame) || visibleFrame.intersects(frame)
    }

    private func layerFrame(at index: Int) -> CGRect {
        return layout.itemFrame(at: index, in: contentView.bounds).rounded()
    }

    private func setup() {
        enable(columns: chart.drawableColumns, animated: false)
    }

    private var enabledColumns: [Column] = []
}

private extension BarColumnLayer {
    static func layers(with chart: Chart) -> [BarColumnLayer] {
        return chart.timestamps.indices
            .map { BarColumnValue.values(of: chart.drawableColumns, at: $0) }
            .map { BarColumnLayer(values: $0) }
    }
}

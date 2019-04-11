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
        self.layers = chartColumns.map { CAShapeLayer.rounded(fill: $0.cgColor) }
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
        invalidateCache()
        draw(animated: animated)
    }

    func draw(animated: Bool) {
        layers.enumerated().forEach { index, layer in
            let points = layerPoints(at: index)
            let path = layerPath(between: points)
            layer.set(path: path, animated: animated)
        }
    }

    private func layerPath(between points: [CGPoint]) -> CGPath {
        let (bl, br) = (bounds.bottomLeft, bounds.bottomRight)
        return CGPath.between(points: [bl] + points + [br])
    }

    private func layerPoints(at index: Int) -> [CGPoint] {
        let spacing = bounds.width / CGFloat(columns.count - 1)
        let points = columnsPoints.compactMap { $0[safe: index] }
        return points.enumerated().map { index, point in
            CGPoint(x: CGFloat(index) * spacing, y: point.y)
        }
    }

    private func invalidateCache() {
        cachedColumnsPoints = []
        cachedHeight = 0
    }

    private func updateCachedColumnsPoints() {
        guard !bounds.isEmpty, columns.count > 1 else {
            return
        }

        cachedHeight = bounds.height
        cachedColumnsPoints = columns.enumerated().map { index, column in
            return column.percentagePoints(height: bounds.height)
        }
    }

    private func setup() {
        isOpaque = true
        layers.reversed().forEach(addSublayer)
        disableActions()
        themeUp()
    }

    private var columnsPoints: [[CGPoint]] {
        isCacheOutdated.onTrue(do: updateCachedColumnsPoints)
        return cachedColumnsPoints
    }

    private var isCacheOutdated: Bool {
        return abs(cachedHeight - bounds.height) > .ulpOfOne
    }

    private var cachedHeight: CGFloat = 0
    private var cachedColumnsPoints: [[CGPoint]] = []

    private var columns: [StackedColumn]
    private let layers: [CAShapeLayer]
}

//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

final class RasterizedBarChartView: ViewportView, ChartViewType {
    let chart: Chart
    var selectedIndex: Int?
    var minViewportSize: CGFloat

    convenience init(chart: Chart, minViewportSize: CGFloat = 1) {
        self.init(
            chart: chart,
            minViewportSize: minViewportSize,
            renderer: BarChartRenderer(chart: chart)
        )
    }

    init(chart: Chart, minViewportSize: CGFloat, renderer: BarChartRenderer) {
        self.chart = chart
        self.renderer = renderer
        self.minViewportSize = minViewportSize
        super.init(frame: .zero)
        setup()
    }

    override func themeUp() {
        super.themeUp()
        contentView.backgroundColor = theme.color.placeholder
    }

    override func layoutSubviewsOnBoundsChange() {
        super.layoutSubviewsOnBoundsChange()
        render(animated: false)
    }

    override func adaptViewportSize() {
        super.adaptViewportSize()
        imageView.bounds = contentView.bounds
        imageView.center = CGPoint(x: imageView.bounds.midX, y: imageView.bounds.height)
    }

    override func display() {
        super.display()
        adaptRange(animated: true)
    }

    func enable(columns: [Column], animated: Bool) {
        enabledColumns = columns
        maxRange = chart.adjustedRange(of: columns)
        render(animated: true)
    }

    func render(animated: Bool) {
        guard !bounds.isEmpty else {
            return
        }

        let image = renderer.render(columns: enabledColumns, size: maxContentSize)
        imageView.set(image: image, animated: animated)
        adaptRange(animated: animated)
    }

    func adaptRange(animated: Bool) {
        let range = chart.adjustedRange(of: enabledColumns, in: viewport)
        let scale = CGFloat(maxRange.size) / CGFloat(range.size)
        print("adapt range with scale: ", scale)
        imageView.transform = CGAffineTransform(scaleX: 1, y: scale)
    }

    private func setup() {
        displayLink.fps = 1
        contentView.addSubview(imageView)
        enable(columns: chart.drawableColumns, animated: false)
    }

    private var maxContentSize: CGSize {
        return CGSize(
            width: bounds.width / minViewportSize,
            height: bounds.height
        )
    }

    private var maxRange: Range<Int> = .zero
    private let renderer: BarChartRenderer
    private let imageView = UIImageView.pixelated()
    private var enabledColumns: [Column] = []
}

private extension UIImageView {
    static func pixelated() -> UIImageView {
        let imageView = UIImageView()
        imageView.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        imageView.layer.minificationFilter = .nearest
        imageView.layer.magnificationFilter = .nearest
        return imageView
    }
}

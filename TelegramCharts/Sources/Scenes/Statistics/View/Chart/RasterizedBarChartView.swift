//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

final class RasterizedBarChartView: ViewportView, ChartViewType {
    let imageView = UIImageView.pixelated()
    let overlayView: BarChartOverlayView
    let minViewportSize: CGFloat
    let chart: Chart

    var selectedIndex: Int? {
        didSet {
            overlayView.selectedIndex = selectedIndex
        }
    }

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
        self.overlayView = BarChartOverlayView(chartLayout: renderer.layout)
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

    override func adaptViewport() {
        super.adaptViewport()
        overlayView.frame = contentView.frame
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

    func enable(columns: [String], animated: Bool) {
        animator.animateColumns(from: enabledColumns.ids, to: columns, animated: animated)
        enabledColumns = chart.columns(with: columns)
        maxRange = chart.adjustedRange(of: enabledColumns)
        render(animated: animated)
    }

    func render(animated: Bool) {
        renderer.render(columns: enabledColumns, size: maxContentSize) { [weak self] image in
            self?.display(image: image, animated: animated)
        }
    }

    private func display(image: UIImage, animated: Bool) {
        imageView.set(image: image, animated: animated)
        adaptRange(animated: animated)
    }

    private func adaptRange(animated: Bool) {
        let range = chart.adjustedRange(of: enabledColumns, in: viewport)
        let scale = CGFloat(maxRange.size) / CGFloat(range.size)
        imageView.layer.scale(byY: scale, animated: animated)
    }

    private func setup() {
        contentView.addSubviews(imageView)
        addSubview(overlayView)
        enable(columns: chart.drawableColumns.ids, animated: false)
    }

    private var maxContentSize: CGSize {
        return CGSize(
            width: bounds.width / minViewportSize,
            height: bounds.height
        )
    }

    private var maxRange: Range<Int> = .zero
    private let renderer: BarChartRenderer
    private var enabledColumns: [Column] = []
    private lazy var animator = RasterizedBarChartAnimator(target: self)
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

//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

final class BarChartOverlayView: View {
    var selectedIndex: Int? {
        didSet {
            update(animated: true)
        }
    }

    init(chartLayout: GridLayout) {
        self.chartLayout = chartLayout
        super.init(frame: .zero)
        setup()
    }

    override func themeUp() {
        super.themeUp()
        let color = theme.color.barOverlay
        leftView.backgroundColor = color
        rightView.backgroundColor = color
    }

    override func layoutSubviewsOnBoundsChange() {
        super.layoutSubviewsOnBoundsChange()
        update(animated: false)
    }

    private func update(animated: Bool) {
        selectedIndex == nil ?
            fadeOut(animated: animated) :
            fadeIn(animated: animated)

        layout()
    }

    private func layout() {
        if let index = selectedIndex {
            layoutIndex = index
        }

        let hole = chartLayout.itemFrame(at: layoutIndex, in: bounds)
        let minX = hole.minX.rounded(.up)
        let maxX = max(minX + 1, hole.maxX.rounded(.down))
        leftView.frame = bounds.slice(at: minX, from: .minXEdge)
        rightView.frame = bounds.remainder(at: maxX, from: .minXEdge)
    }

    private func fadeIn(animated: Bool) {
        leftView.set(alpha: 1, animated: animated)
        rightView.set(alpha: 1, animated: animated)
    }

    private func fadeOut(animated: Bool) {
        leftView.set(alpha: 0, animated: animated)
        rightView.set(alpha: 0, animated: animated)
    }

    private func setup() {
        isUserInteractionEnabled = false
        addSubviews(leftView, rightView)
        fadeOut(animated: false)
        themeUp()
    }

    private let chartLayout: GridLayout
    private let leftView = UIView()
    private let rightView = UIView()
    private var layoutIndex: Int = 0
}

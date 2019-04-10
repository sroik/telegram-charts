//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

final class BarChartOverlayView: View {
    var selectedIndex: Int? {
        didSet {
            if oldValue != selectedIndex {
                update(animated: true)
            }
        }
    }

    init(chartLayout: GridLayout) {
        self.chartLayout = chartLayout
        super.init(frame: .zero)
        setup()
    }

    override func themeUp() {
        super.themeUp()
        leftView.backgroundColor = theme.color.placeholder.withAlphaComponent(0.5)
        rightView.backgroundColor = theme.color.placeholder.withAlphaComponent(0.5)
    }

    override func layoutSubviewsOnBoundsChange() {
        super.layoutSubviewsOnBoundsChange()
        update(animated: true)
    }

    private func update(animated: Bool) {
        guard let index = selectedIndex else {
            deselect(animated: animated)
            return
        }

        layout(at: index)
    }

    private func layout(at index: Int) {
        let holeFrame = chartLayout.itemFrame(at: index, in: bounds)
        leftView.frame = bounds.slice(at: holeFrame.minX, from: .minXEdge)
        rightView.frame = bounds.remainder(at: holeFrame.maxX, from: .minXEdge)
    }

    private func deselect(animated: Bool) {
        
    }

    private func setup() {
        addSubviews(leftView, rightView)
        deselect(animated: false)
        themeUp()
    }

    private let chartLayout: GridLayout
    private let leftView = UIView()
    private let rightView = UIView()
}

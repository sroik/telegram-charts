//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

final class BarChartOverlayView: View {
    var selectedIndex: Int? {
        didSet {
            if oldValue != selectedIndex {
                select(index: selectedIndex, animated: true)
            }
        }
    }

    init(chartLayout: GridLayout) {
        self.chartLayout = chartLayout
        super.init(frame: .zero)
        deselect(animated: false)
        themeUp()
    }

    override func themeUp() {
        super.themeUp()
        leftView.backgroundColor = theme.color.placeholder.withAlphaComponent(0.5)
        rightView.backgroundColor = theme.color.placeholder.withAlphaComponent(0.5)
    }

    private func select(index: Int?, animated: Bool) {
        guard let index = index else {
            deselect(animated: animated)
            return
        }

        let holeFrame = chartLayout.itemFrame(at: index, in: bounds)
        leftView.frame = bounds.slice(at: holeFrame.minX, from: .minXEdge)
        rightView.frame = bounds.remainder(at: holeFrame.maxX, from: .minXEdge)
        addSubviews(leftView, rightView)
    }

    private func deselect(animated: Bool) {
        selectedIndex = nil
//        leftView.removeFromSuperview()
//        rightView.removeFromSuperview()
    }

    private let chartLayout: GridLayout
    private let leftView = UIView()
    private let rightView = UIView()
}

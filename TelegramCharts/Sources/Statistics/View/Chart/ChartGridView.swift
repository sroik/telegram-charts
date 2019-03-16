//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

final class ChartGridView: View {
    init(layout: ChartGridLayout = .default) {
        self.layout = layout
        super.init(frame: .zero)
    }

    override func layoutSubviewsOnBoundsChange() {
        super.layoutSubviewsOnBoundsChange()
        rebuildLines()
    }

    override func themeUp() {
        super.themeUp()
        lines.forEach { $0.backgroundColor = lineColor }
    }

    private func rebuildLines() {
        lines.forEach { $0.removeFromSuperview() }
        lines.removeAll()

        (0 ..< linesNumber - 1).forEach { index in
            let line = UIView()
            line.backgroundColor = lineColor
            line.frame = lineFrame(at: index)
            addSubview(line)
            lines.append(line)
        }
    }

    private func lineFrame(at index: Int) -> CGRect {
        let frame = layout.itemFrame(at: index, in: bounds)
        let pixelHeightFrame = frame.divided(atDistance: .pixel, from: .maxYEdge).slice
        return pixelHeightFrame
    }

    private var linesNumber: Int {
        return layout.itemsNumber(in: bounds)
    }

    private var lineColor: UIColor {
        return theme.color.line.withAlphaComponent(0.35)
    }

    private var lines: [UIView] = []
    private let layout: ChartGridLayout
}

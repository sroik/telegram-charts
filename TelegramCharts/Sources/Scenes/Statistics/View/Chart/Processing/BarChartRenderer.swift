//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

final class BarChartRenderer {
    var queue = DispatchQueue(label: "com.sroik.rendering")
    let layout: GridLayout
    let chart: Chart
    let scale: CGFloat = min(2, UIScreen.main.scale)

    init(chart: Chart) {
        self.chart = chart
        self.layout = GridLayout(itemsNumber: chart.timestamps.count)
    }

    func render(columns: [Column], size: CGSize) -> UIImage {
        let rect = CGRect(origin: .zero, size: size * scale)
        let format = UIGraphicsImageRendererFormat.defaultUnscaled()
        let renderer = UIGraphicsImageRenderer(size: rect.size, format: format)
        return renderer.image { ctx in
            ctx.cgContext.setAllowsAntialiasing(false)
            render(columns: columns, in: rect, in: ctx)
        }
    }

    func render(columns: [Column], in rect: CGRect, in context: UIGraphicsRendererContext) {
        let layout = GridLayout(itemsNumber: chart.timestamps.count)
        let range = chart.adjustedRange(of: columns)
        let frames = layout.itemFrames(in: rect)

        frames.enumerated().forEach { index, frame in
            BarColumnRenderer().render(
                column: StackedColumn(columns: columns, at: index),
                range: range,
                in: frame.rounded(),
                in: context,
                minHeight: scale
            )
        }
    }

    func render(columns: [Column], size: CGSize, then block: @escaping (UIImage) -> Void) {
        queue.async {
            let image = self.render(columns: columns, size: size)
            DispatchQueue.main.async {
                block(image)
            }
        }
    }
}

private extension UIGraphicsImageRendererFormat {
    static func defaultUnscaled() -> UIGraphicsImageRendererFormat {
        let format = self.default()
        format.scale = 1
        return format
    }
}
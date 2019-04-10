//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

final class BarChartRenderer {
    var queue = DispatchQueue(label: "com.sroik.rendering")
    let layout: GridLayout
    let chart: Chart

    init(chart: Chart) {
        self.chart = chart
        self.layout = GridLayout(itemsNumber: chart.timestamps.count)
    }

    func render(columns: [Column], size: CGSize) -> UIImage {
        let rect = CGRect(origin: .zero, size: size)
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { ctx in
            ctx.cgContext.interpolationQuality = .none
            ctx.cgContext.setAllowsAntialiasing(false)
            render(columns: columns, in: rect, in: ctx)
        }
    }

    func render(columns: [Column], in rect: CGRect, in context: UIGraphicsRendererContext) {
        let layout = GridLayout(itemsNumber: chart.timestamps.count)
        let range = chart.adjustedRange(of: columns, in: .zeroToOne)
        let frames = layout.itemFrames(in: rect)

        frames.enumerated().forEach { index, frame in
            BarColumnRenderer().render(
                values: BarColumnValue.values(of: columns, at: index),
                range: range,
                in: frame,
                in: context
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

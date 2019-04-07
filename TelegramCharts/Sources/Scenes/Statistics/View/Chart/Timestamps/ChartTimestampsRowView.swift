//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

final class ChartTimestampsRowView: View {
    var count: Int {
        return labels.count
    }

    init(itemWidth: CGFloat, timestamps: [Timestamp]) {
        self.timestamps = timestamps
        self.itemWidth = itemWidth
        super.init(frame: .screen)
        setup()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateFrames()
    }

    override func themeUp() {
        super.themeUp()
        labels.forEach {
            $0.textColor = theme.color.details
        }
    }

    private func updateFrames() {
        labels.enumerated().forEach { index, label in
            label.frame = labelFrame(at: index)
        }
    }

    private func buildLabel(for timestamp: Timestamp) -> Label {
        return Label.details(
            text: Date(timestamp: timestamp).string(format: "d MMM"),
            color: theme.color.details,
            alignment: .right
        )
    }

    private func labelFrame(at index: Index) -> CGRect {
        return CGRect(
            x: CGFloat(index + 1) * spacing - itemWidth,
            y: 0,
            width: itemWidth,
            height: bounds.height
        )
    }

    private func setup() {
        timestamps.forEach {
            let label = buildLabel(for: $0)
            labels.append(label)
            addSubview(label)
        }
    }

    private var spacing: CGFloat {
        return bounds.width / CGFloat(labels.count)
    }

    private let itemWidth: CGFloat
    private let timestamps: [Timestamp]
    private var labels: [Label] = []
}

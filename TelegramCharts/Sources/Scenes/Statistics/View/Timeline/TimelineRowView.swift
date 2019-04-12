//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

final class TimelineRowView: View {
    var count: Int {
        return timestamps.count
    }

    var visibleRect: CGRect = .zero {
        didSet {
            layoutLabels()
        }
    }

    init(itemWidth: CGFloat, timestamps: [Timestamp], format: String) {
        self.timestamps = timestamps
        self.formatter = DateFormatter(format: format)
        self.layout = GridLayout(
            itemSide: .fixed(itemWidth),
            itemsNumber: timestamps.count
        )
        super.init(frame: .zero)
    }

    override func layoutSubviewsOnBoundsChange() {
        super.layoutSubviewsOnBoundsChange()
        layoutLabels()
    }

    override func themeUp() {
        super.themeUp()
        labels.values.forEach { label in
            label.textColor = theme.color.details
        }
    }

    func layoutLabels() {
        timestamps.enumerated().forEach { index, timestamp in
            guard isVisibleLabel(at: index) else {
                labels[index]?.removeFromSuperviewIfNeeded()
                return
            }

            let label = self.label(at: index, with: timestamp)
            label.frame = layout.itemFrame(at: index, in: bounds)
            addSubviewIfNeeded(label)
        }
    }

    private func isVisibleLabel(at index: Int) -> Bool {
        let frame = layout.itemFrame(at: index, in: bounds)
        return visibleRect.intersects(frame)
    }

    private func label(at index: Index, with timestamp: Timestamp) -> UILabel {
        if let label = labels[index] {
            return label
        }

        let label = buildLabel(at: index, with: timestamp)
        labels[index] = label
        return label
    }

    private func buildLabel(at index: Int, with timestamp: Timestamp) -> Label {
        let label = Label()
        let date = Date(timestamp: timestamp).nearestHour
        label.textAlignment = alignment(at: index)
        label.text = formatter.string(from: date)
        label.font = font
        label.textColor = theme.color.details
        return label
    }

    private func alignment(at index: Int) -> NSTextAlignment {
        let half = timestamps.count / 2
        switch index {
        case half:
            return .center
        case 0 ..< half:
            return .left
        default:
            return .right
        }
    }

    private let font = UIFont.light(size: 11)
    private let formatter: DateFormatter
    private let layout: GridLayout
    private let timestamps: [Timestamp]
    private var labels: [Int: Label] = [:]
}

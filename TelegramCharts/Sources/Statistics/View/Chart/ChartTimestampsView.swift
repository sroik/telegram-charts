//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

final class ChartTimestampsView: View {
    static let preferredHeight: CGFloat = 20

    var minimumSpacing: CGFloat = 50.0 {
        didSet {
            update()
        }
    }

    init(timestamps: [Timestamp]) {
        self.timestamps = timestamps
        super.init(frame: .screen)
        setup()
    }

    override func layoutSubviewsOnBoundsChange() {
        super.layoutSubviewsOnBoundsChange()
        update()
    }

    override func themeUp() {
        super.themeUp()
        line.backgroundColor = theme.color.line
        labels.values.forEach { $0.textColor = theme.color.details }
    }

    private func update() {
        guard timestamps.count > 0 else {
            return
        }

//        labels.values.forEach { $0.removeFromSuperview() }
//        labels.removeAll()

//        let fitLabelsNumber = Int(bounds.width / minimumSpacing)
//        let fitLabelsStride = 1 + (timestamps.count / fitLabelsNumber)

//        timestamps.enumerated().forEach { index, timestamp in
//            let label = buildLabel(for: timestamp)
//            label.text = "\(index)"
//            labels[index] = label
//            label.frame =
//            addSubview(label)
//        }
    }

    private func setup() {
        line.anchor(
            in: self,
            bottom: topAnchor,
            left: leftAnchor,
            right: rightAnchor,
            height: .pixel
        )
    }

    private func buildLabel(for timestamp: Timestamp) -> Label {
        return Label.primary(
            text: "Feb 10",
            color: theme.color.details,
            font: UIFont.systemFont(ofSize: 10)
        )
    }

    private var labels: [Index: Label] = [:]
    private let timestamps: [Timestamp]
    private let line = UIView()
}

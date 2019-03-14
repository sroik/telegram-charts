//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

final class ChartTimestampsView: View {
    static let preferredHeight: CGFloat = 20

    init(timestamps: [Timestamp]) {
        self.timestamps = timestamps
        super.init(frame: .screen)
        setup()
    }

    override func layoutSubviewsOnBoundsChange() {
        super.layoutSubviewsOnBoundsChange()
        layout()
    }

    override func themeUp() {
        super.themeUp()
        line.backgroundColor = theme.color.line
        labels.values.forEach { $0.textColor = theme.color.details }
    }

    private func layout() {
        print("LAYOUT")
    }

    private func setup() {
        line.anchor(
            in: self,
            bottom: topAnchor,
            left: leftAnchor,
            right: rightAnchor,
            height: .pixel
        )

        timestamps.forEach { timestamp in
            let label = buildLabel(for: timestamp)
            labels[timestamp] = label
            addSubview(label)
        }
    }

    private func buildLabel(for timestamp: Timestamp) -> Label {
        return Label.primary(
            text: "Feb 10",
            color: theme.color.details,
            font: UIFont.systemFont(ofSize: 9)
        )
    }

    private var labels: [Timestamp: Label] = [:]
    private let timestamps: [Timestamp]
    private let line = UIView()
}

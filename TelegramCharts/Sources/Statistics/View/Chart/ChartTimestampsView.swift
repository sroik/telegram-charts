//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

final class ChartTimestampsView: View {
    static let preferredHeight: CGFloat = 20.0

    init(timestamps: [Timestamp]) {
        self.timestamps = timestamps
        super.init(frame: .screen)
        setup()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }

    private func layout() {}

    private func setup() {
        line.anchor(
            in: self,
            bottom: topAnchor,
            left: leftAnchor,
            right: rightAnchor,
            height: .pixel
        )
    }

    override func themeUp() {
        super.themeUp()
        line.backgroundColor = theme.color.line
    }

    private let timestamps: [Timestamp]
    private let line = UIView()
}

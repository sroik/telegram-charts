//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

final class ChartValuesViewCell: View {
    var value: Int = 0 {
        didSet {
            label.text = String(value)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    override func themeUp() {
        super.themeUp()
        label.textColor = theme.color.details
        line.backgroundColor = theme.color.line.withAlphaComponent(0.5)
    }

    private func setup() {
        line.anchor(
            in: self,
            bottom: bottomAnchor,
            left: leftAnchor,
            right: rightAnchor,
            height: .pixel
        )

        label.anchor(
            in: self,
            bottom: bottomAnchor,
            left: leftAnchor,
            bottomOffset: 3
        )
    }

    private let line = UIView()
    private let label = Label.primary(font: UIFont.systemFont(ofSize: 10))
}

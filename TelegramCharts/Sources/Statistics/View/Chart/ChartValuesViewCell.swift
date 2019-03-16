//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

final class ChartValuesViewCell: View {
    var isUnderlined: Bool = true {
        didSet {
            line.isHidden = !isUnderlined
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    override func themeUp() {
        super.themeUp()
        label.textColor = theme.color.details
        line.backgroundColor = theme.color.line.withAlphaComponent(0.35)
    }

    func set(value: Int, animated: Bool) {
        label.set(text: String(value), animated: animated)
    }

    private func setup() {
        label.fill(in: self)
        line.anchor(
            in: self,
            bottom: bottomAnchor,
            left: leftAnchor,
            right: rightAnchor,
            height: .pixel
        )
    }

    private let line = UIView()
    private let label = Label.primary(
        font: UIFont.systemFont(ofSize: 10),
        alignment: .left
    )
}

//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

final class StatisticsTableThemeButton: View {
    typealias Callback = () -> Void

    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 114)
    }

    var onTap: Callback?

    var title: String? {
        didSet {
            button.setTitle(title, for: .normal)
        }
    }

    init(onTap: Callback? = nil) {
        super.init(frame: .zero)
        self.onTap = onTap
        setup()
    }

    private func setup() {
        backgroundColor = .clear
        placeholder.anchor(
            in: self,
            left: leftAnchor,
            right: rightAnchor,
            height: 44,
            centerY: centerYAnchor
        )

        button.fill(in: placeholder)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
    }

    override func themeUp() {
        super.themeUp()
        button.setTitleColor(theme.color.tint, for: .normal)
    }

    @objc private func buttonPressed() {
        onTap?()
    }

    private let button = UIButton()
    private let placeholder = Placeholder()
}

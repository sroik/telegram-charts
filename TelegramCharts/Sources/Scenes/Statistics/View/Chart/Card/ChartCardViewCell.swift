//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

final class ChartCardViewCell: View {
    let summaryLabel: Label
    let titleLabel: Label
    let valueLabel: Label
    let iconView: UIImageView

    var value: String? {
        didSet {
            valueLabel.text = value
        }
    }

    var summary: String? {
        didSet {
            summaryLabel.text = value
        }
    }

    var valueColor: UIColor? {
        didSet {
            valueLabel.textColor = valueColor ?? theme.color.popupText
        }
    }

    override var intrinsicContentSize: CGSize {
        let leftWidth = leftStack.intrinsicContentSize.width
        let rightWidth = rightStack.intrinsicContentSize.width
        return CGSize(
            width: leftWidth + rightWidth + spacing,
            height: UIView.noIntrinsicMetric
        )
    }

    init(
        summary: String? = nil,
        title: String? = nil,
        value: String? = nil,
        valueColor: UIColor? = nil,
        icon: UIImage? = nil
    ) {
        self.summary = summary
        self.value = value
        self.valueColor = valueColor
        self.valueLabel = Label.primary(text: value, font: UIFont.bold(size: 11))
        self.summaryLabel = Label.primary(text: summary, font: UIFont.bold(size: 11))
        self.titleLabel = Label.primary(text: title, font: UIFont.light(size: 11))
        self.iconView = UIImageView(image: icon)
        self.leftStack = UIStackView(arrangedSubviews: [summaryLabel, titleLabel])
        self.rightStack = UIStackView(arrangedSubviews: [valueLabel, iconView])
        super.init(frame: .zero)
        setup()
    }

    override func themeUp() {
        super.themeUp()
        summaryLabel.textColor = theme.color.popupText
        titleLabel.textColor = theme.color.popupText
        iconView.tintColor = theme.color.popupText.withAlphaComponent(0.5)
        valueLabel.textColor = valueColor ?? theme.color.popupText
    }

    private func setup() {
        iconView.contentMode = .center

        leftStack.axis = .horizontal
        leftStack.distribution = .fill
        leftStack.alignment = .fill
        leftStack.spacing = spacing
        leftStack.anchor(
            in: self,
            top: topAnchor,
            bottom: bottomAnchor,
            left: leftAnchor
        )

        rightStack.axis = .horizontal
        rightStack.distribution = .fill
        rightStack.alignment = .fill
        rightStack.spacing = spacing
        rightStack.anchor(
            in: self,
            top: topAnchor,
            bottom: bottomAnchor,
            right: rightAnchor
        )
    }

    private let spacing: CGFloat = 5
    private let leftStack: UIStackView
    private let rightStack: UIStackView
}

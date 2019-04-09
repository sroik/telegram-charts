//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

final class ChartCardViewCell: View {
    let id: String?
    let summaryLabel: Label
    let titleLabel: Label
    let valueLabel: Label
    let iconView: UIImageView

    var value: String? {
        didSet {
            valueLabel.text = value
            setNeedsLayout()
        }
    }

    var title: String? {
        didSet {
            titleLabel.text = title
            setNeedsLayout()
        }
    }

    var summary: String? {
        didSet {
            summaryLabel.text = summary
            setNeedsLayout()
        }
    }

    var icon: UIImage? {
        didSet {
            iconView.image = icon
            setNeedsLayout()
        }
    }

    var valueColor: UIColor? {
        didSet {
            valueLabel.textColor = valueColor ?? theme.color.popupText
        }
    }

    override var intrinsicContentSize: CGSize {
        let lablesWidth: CGFloat = [titleLabel, summaryLabel, iconView, valueLabel]
            .map { $0.intrinsicContentSize }
            .reduce(0) { $0 + $1.width }

        return CGSize(
            width: lablesWidth + 2 * spacing,
            height: UIView.noIntrinsicMetric
        )
    }

    init(
        id: String? = nil,
        summary: String? = nil,
        title: String? = nil,
        value: String? = nil,
        valueColor: UIColor? = nil,
        icon: UIImage? = nil
    ) {
        self.id = id
        self.summary = summary
        self.value = value
        self.valueColor = valueColor
        self.valueLabel = Label.primary(text: value, font: UIFont.bold(size: 12))
        self.summaryLabel = Label.primary(text: summary, font: UIFont.bold(size: 12))
        self.titleLabel = Label.primary(text: title, font: UIFont.regular(size: 12))
        self.iconView = UIImageView(image: icon)
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

    override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }

    private func layout() {
        let iconWidth = iconView.image?.size.width ?? 0
        let summaryWidth = summaryLabel.intrinsicContentSize.width
        let titleOffset = summaryWidth > 1 ? summaryWidth + spacing : 0

        iconView.frame = bounds.slice(at: iconWidth, from: .maxXEdge)
        valueLabel.frame = bounds.remainder(at: iconWidth, from: .maxXEdge)
        summaryLabel.frame = bounds.slice(at: summaryWidth, from: .minXEdge)
        titleLabel.frame = bounds.remainder(at: titleOffset, from: .minXEdge)
    }

    private func setup() {
        summaryLabel.textAlignment = .left
        titleLabel.textAlignment = .left
        valueLabel.textAlignment = .right
        iconView.contentMode = .center
        addSubviews(summaryLabel, titleLabel, iconView, valueLabel)
    }

    private let spacing: CGFloat = 5
}

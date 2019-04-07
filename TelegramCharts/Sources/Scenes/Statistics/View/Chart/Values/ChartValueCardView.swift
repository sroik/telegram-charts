//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

final class ChartValueCardView: Control {
    var index: Int = 0 {
        didSet {
            update()
        }
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(
            width: 145,
            height: insets.vertical + max(dateStackHeight, valuesStackHeight)
        )
    }

    init(chart: Chart) {
        self.chart = chart
        super.init(frame: .zero)
        setup()
    }

    override func layoutSubviewsOnBoundsChange() {
        super.layoutSubviewsOnBoundsChange()
        dateStackView.frame = insets.inset(bounds).with(height: dateStackHeight)
        valuesStackView.frame = insets.inset(bounds).with(height: valuesStackHeight)
    }

    override func themeUp() {
        super.themeUp()
        backgroundColor = theme.color.popup
        dayLabel.textColor = theme.color.popupText
        yearLabel.textColor = theme.color.popupText
    }

    private func update() {
        dayLabel.text = date?.monthDayString
        yearLabel.text = date?.yearString

        chart.drawableColumns.forEach { column in
            guard let value = column.values[safe: index] else {
                assertionFailureWrapper("index out of bounds")
                return
            }

            labels[column.label]?.text = String(value)
        }
    }

    private func setup() {
        isUserInteractionEnabled = false
        layer.cornerRadius = 6
        addSubview(dateStackView)
        addSubview(valuesStackView)

        chart.drawableColumns.forEach { column in
            let label = buildLabel(for: column)
            labels[column.label] = label
            valuesStackView.addArrangedSubview(label)
        }
    }

    private func buildLabel(for column: Column) -> Label {
        return Label.primary(
            color: column.uiColor,
            font: UIFont.systemFont(ofSize: 11, weight: .bold),
            alignment: .right
        )
    }

    private var date: Date? {
        return timestamp.flatMap(Date.init(timestamp:))
    }

    private var timestamp: Timestamp? {
        return chart.timestamps[safe: index]
    }

    private var valuesStackHeight: CGFloat {
        return CGFloat(valuesStackView.arrangedSubviews.count) * labelHeight
    }

    private var dateStackHeight: CGFloat {
        return CGFloat(dateStackView.arrangedSubviews.count) * labelHeight
    }

    private lazy var valuesStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        return stack
    }()

    private lazy var dateStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [dayLabel, yearLabel])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        return stack
    }()

    private let dayLabel = Label.primary(
        font: UIFont.systemFont(ofSize: 11, weight: .bold),
        alignment: .left
    )

    private let yearLabel = Label.primary(
        font: UIFont.systemFont(ofSize: 11, weight: .light),
        alignment: .left
    )

    private var labels: [String: Label] = [:]
    private let insets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
    private let labelHeight: CGFloat = 15
    private let chart: Chart
}

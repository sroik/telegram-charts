//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

final class ChartColumnsStackViewCell: Control {
    override var isSelected: Bool {
        didSet {
            updateState()
        }
    }

    let column: Column
    let inset: CGFloat = 15

    init(column: Column) {
        self.column = column
        super.init(frame: .screen)
        setup()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        colorView.frame = CGRect(
            x: inset,
            midY: bounds.midY,
            width: 11.5,
            height: 11.5
        )

        checkmarkView.frame = CGRect(
            x: bounds.width - 20 - inset,
            midY: bounds.midY,
            width: 20,
            height: 20
        )

        separator.frame = CGRect(
            x: 44,
            y: bounds.height - .pixel,
            width: bounds.width - 44,
            height: .pixel
        )

        label.frame = CGRect(
            x: colorView.frame.maxX + inset,
            y: 0,
            width: checkmarkView.frame.minX - colorView.frame.maxX - inset,
            height: bounds.height
        )
    }

    private func setup() {
        colorView.layer.cornerRadius = 2.5
        colorView.backgroundColor = column.uiColor
        label.text = column.name
        checkmarkView.contentMode = .right
        addSubviews(colorView, label, separator, checkmarkView)
        updateState()
    }

    override func themeUp() {
        super.themeUp()
        separator.backgroundColor = theme.color.line
        checkmarkView.tintColor = theme.color.tint
        label.textColor = theme.color.text
    }

    private func updateState() {
        checkmarkView.isHidden = !isSelected
    }

    private let colorView = UIView()
    private let separator = UIView()
    private let checkmarkView = UIImageView(image: Image.checkmark)
    private let label = Label.primary(font: UIFont.systemFont(ofSize: 16), alignment: .left)
}

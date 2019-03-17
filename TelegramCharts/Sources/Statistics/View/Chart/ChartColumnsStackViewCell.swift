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

    init(column: Column) {
        self.column = column
        super.init(frame: .screen)
        setup()
    }

    private func setup() {
        colorView.layer.cornerRadius = 2.5
        colorView.backgroundColor = column.uiColor
        colorView.anchor(
            in: self,
            left: leftAnchor,
            leftOffset: 15,
            width: 11.5, height: 11.5,
            centerY: centerYAnchor
        )

        label.text = column.name
        label.anchor(
            in: self,
            left: colorView.rightAnchor,
            leftOffset: 15,
            centerY: centerYAnchor
        )

        separator.anchor(
            in: self,
            top: bottomAnchor,
            left: leftAnchor,
            right: rightAnchor,
            leftOffset: 44,
            height: .pixel
        )

        checkmarkView.contentMode = .scaleAspectFit
        checkmarkView.anchor(
            in: self,
            right: rightAnchor,
            rightOffset: 15,
            width: 12.5, height: 12.5,
            centerY: centerYAnchor
        )

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
    private let checkmarkView = UIImageView(image: UIImage(named: "checkmark"))
    private let label = Label.primary(font: UIFont.systemFont(ofSize: 16), alignment: .left)
}

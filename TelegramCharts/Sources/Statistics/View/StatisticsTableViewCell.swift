//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

final class StatisticsTableViewCell: UITableViewCell, Themeable {
    var theme: Theme = .day {
        didSet {
            themeUp()
        }
    }

    var title: String? {
        didSet {
            themeUp()
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        themeUp()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    private func setup() {
        label.anchor(
            in: contentView,
            top: contentView.topAnchor,
            left: contentView.leftAnchor,
            topOffset: 10,
            leftOffset: 10,
            height: 30
        )

        placeholder.anchor(
            in: contentView,
            top: label.bottomAnchor,
            bottom: contentView.bottomAnchor,
            left: contentView.leftAnchor,
            right: contentView.rightAnchor
        )
    }

    private func themeUp() {
        placeholder.theme = theme
        backgroundColor = .clear
        label.text = title?.uppercased()
        label.textColor = theme.color.header
        label.backgroundColor = theme.color.background
    }

    private let placeholder = Placeholder()
    private let label = Label.primary(font: UIFont.systemFont(ofSize: 13), alignment: .left)
}

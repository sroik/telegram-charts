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
            right: contentView.rightAnchor,
            leftOffset: 10,
            height: 35
        )
    }

    private func themeUp() {
        backgroundColor = .clear
        label.text = title?.uppercased()
        label.textColor = theme.color.details
        label.backgroundColor = theme.color.placeholder
    }

    private let label = Label.primary(
        font: UIFont.systemFont(ofSize: 13),
        alignment: .left
    )
}

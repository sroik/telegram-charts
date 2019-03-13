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

    var controller: ViewController? {
        didSet {
            oldValue?.view.removeFromSuperview()
            layoutController()
        }
    }

    var title: String? {
        didSet {
            label.text = title?.uppercased()
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

    override func prepareForReuse() {
        super.prepareForReuse()
        controller = nil
        title = nil
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layoutController()
    }

    private func setup() {
        label.anchor(
            in: contentView,
            top: contentView.topAnchor,
            left: contentView.leftAnchor,
            topOffset: 15,
            leftOffset: 15,
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

    private func layoutController() {
        guard !bounds.isEmpty, controller?.view.superview != placeholder else {
            return
        }

        controller?.view.fill(in: placeholder)
        controller?.theme = theme
    }

    private func themeUp() {
        placeholder.theme = theme
        controller?.theme = theme
        backgroundColor = .clear
        label.textColor = theme.color.header
        label.backgroundColor = theme.color.background
    }

    private let placeholder = Placeholder()
    private let label = Label.primary(font: UIFont.systemFont(ofSize: 13), alignment: .left)
}

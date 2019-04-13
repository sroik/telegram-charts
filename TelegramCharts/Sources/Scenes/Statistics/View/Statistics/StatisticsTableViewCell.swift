//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

final class StatisticsTableViewCell: UITableViewCell, Themeable {
    var theme: Theme = .day {
        didSet {
            if oldValue != theme {
                themeUp()
            }
        }
    }

    var controller: ViewController? {
        didSet {
            oldValue?.view.removeFromSuperview()
            controller?.view.removeFromSuperview()
            layoutControllerIfNeeded()
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
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = CGRect(x: 15, y: 15, width: bounds.width, height: 30)
        placeholder.frame = bounds.inset(by: UIEdgeInsets(top: label.frame.maxY))
        layoutControllerIfNeeded()
    }

    private func setup() {
        contentView.addSubview(label)
        contentView.addSubview(placeholder)
    }

    private func themeUp() {
        placeholder.theme = theme
        controller?.theme = theme
        backgroundColor = .clear
        label.textColor = theme.color.details
        label.backgroundColor = theme.color.background
    }

    private func layoutControllerIfNeeded() {
        guard !placeholder.bounds.isEmpty, let controller = controller else {
            return
        }

        controller.view.frame = placeholder.bounds
        controller.hasSuperview.onFalse {
            placeholder.addSubview(controller.view)
        }
    }

    private let placeholder = Placeholder()
    private let label = Label.primary(font: UIFont.systemFont(ofSize: 13), alignment: .left)
}

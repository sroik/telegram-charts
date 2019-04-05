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
            setNeedsLayout()
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
        guard !bounds.isEmpty else {
            return
        }

        label.frame = CGRect(x: 15, y: 15, width: contentView.bounds.width, height: 30)
        placeholder.frame = contentView.bounds.inset(by: UIEdgeInsets(top: label.frame.maxY))

//        if let controller = controller {
//            controller.view.frame = placeholder.bounds
//            controller.theme = theme
//            controller.hasSuperview.onFalse {
//                placeholder.addSubview(controller.view)
//            }
//        }
    }

    private func setup() {
        contentView.addSubview(label)
        contentView.addSubview(placeholder)
    }

    private func themeUp() {
        placeholder.theme = theme
        controller?.theme = theme
        backgroundColor = .clear
        label.textColor = theme.color.header
        label.backgroundColor = theme.color.background
        #warning("fix")
        placeholder.backgroundColor = .red
    }

    private let placeholder = Placeholder()
    private let label = Label.primary(font: UIFont.systemFont(ofSize: 13), alignment: .left)
}

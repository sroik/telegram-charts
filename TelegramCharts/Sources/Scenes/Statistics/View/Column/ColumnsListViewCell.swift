//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

final class ColumnsListViewCell: Control {
    override var intrinsicContentSize: CGSize {
        let labelWidth = label.intrinsicContentSize.width
        let checkmarkWidth = checkmarkView.intrinsicContentSize.width
        return CGSize(
            width: insets.horizontal + spacing + checkmarkWidth + labelWidth,
            height: UIView.noIntrinsicMetric
        )
    }

    let column: Column

    init(column: Column) {
        self.column = column
        super.init(frame: .screen)
        setup()
    }

    override func layoutSubviewsOnBoundsChange() {
        super.layoutSubviewsOnBoundsChange()
        update(animated: false)
    }

    func toggle(animated: Bool = true) {
        isSelected.toggle()
        update(animated: animated)
    }

    func update(animated: Bool) {
        guard animated, !bounds.isEmpty else {
            update()
            return
        }

        layer.blink(
            scale: 0.875,
            duration: .defaultDuration
        )

        UIView.animate(
            withDuration: .defaultDuration,
            delay: 0, options: .curveEaseInOut,
            animations: update,
            completion: nil
        )
    }

    private func update() {
        let tintColor = isSelected ? .white : column.uiColor
        let scale: CGFloat = isSelected ? 1 : 0.75

        checkmarkView.alpha = isSelected ? 1 : 0
        checkmarkView.transform = CGAffineTransform(scaleX: scale, y: scale)
        checkmarkView.frame = checkmarkFrame
        checkmarkView.tintColor = tintColor

        label.textColor = tintColor
        label.frame = labelFrame
        backgroundColor = isSelected ? column.uiColor : .clear
    }

    private func setup() {
        layer.cornerRadius = theme.state.cornerRadius
        layer.borderWidth = 1.5
        layer.borderColor = column.cgColor
        checkmarkView.contentMode = .center
        checkmarkView.tintColor = .white
        label.text = column.name
        label.contentMode = .center
        addSubviews(checkmarkView, label)
        isSelected = true
    }

    private var labelFrame: CGRect {
        return isSelected ?
            contentFrame.remainder(at: checkmarkFrame.width + spacing, from: .minXEdge) :
            contentFrame
    }

    private var checkmarkFrame: CGRect {
        return contentFrame.slice(
            at: checkmarkView.image?.size.width ?? 0,
            from: .minXEdge
        )
    }

    private var contentFrame: CGRect {
        return bounds.inset(by: insets)
    }

    private let checkmarkView = UIImageView(image: Image.checkmark)
    private let label = Label.primary(font: UIFont.medium(size: 13))
    private let insets = UIEdgeInsets(right: 10, left: 10)
    private let spacing: CGFloat = 6
}

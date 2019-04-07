//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

final class ChartGridViewCell: View, Updateable {
    var isLineHidden: Bool = false {
        didSet {
            line.isHidden = isLineHidden
        }
    }

    var value: Int {
        didSet {
            updateValue()
        }
    }

    init(value: Int = 0) {
        self.value = value
        super.init(frame: .screen)
        setup()
    }

    override func layoutSubviewsOnBoundsChange() {
        super.layoutSubviewsOnBoundsChange()
        line.frame = bounds.slice(at: .pixel, from: .maxYEdge)
        label.frame = bounds
    }

    override func themeUp() {
        super.themeUp()
        label.textColor = theme.color.details
        line.backgroundColor = theme.color.details.withAlphaComponent(0.35)
    }

    func updateValue() {
        label.text = String(columnValue: value)
    }

    private func setup() {
        addSubviews(line, label)
        updateValue()
    }

    private var lineColor: UIColor {
        return theme.color.line.withAlphaComponent(0.35)
    }

    private let label = Label.details(alignment: .left)
    private let line = UIView()
}

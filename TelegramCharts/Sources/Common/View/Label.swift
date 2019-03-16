//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

final class Label: UILabel {}

extension Label {
    static func details(
        text: String? = nil,
        color: UIColor = .white,
        alignment: NSTextAlignment = .center
    ) -> Label {
        return primary(
            text: text,
            color: color,
            font: UIFont.systemFont(ofSize: 10),
            alignment: alignment
        )
    }

    static func primary(
        text: String? = nil,
        color: UIColor = .white,
        font: UIFont,
        alignment: NSTextAlignment = .center,
        numberOfLines: Int = 1
    ) -> Label {
        let label = Label()
        label.textAlignment = alignment
        label.text = text
        label.font = font
        label.textColor = color
        label.numberOfLines = numberOfLines
        label.adjustsFontSizeToFitWidth = true
        label.baselineAdjustment = .alignCenters
        return label
    }
}

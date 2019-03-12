//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

class Placeholder: View {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    private func setup() {
        topLine.anchor(
            in: self,
            bottom: topAnchor,
            left: leftAnchor,
            right: rightAnchor,
            height: .pixel
        )

        bottomLine.anchor(
            in: self,
            top: bottomAnchor,
            left: leftAnchor,
            right: rightAnchor,
            height: .pixel
        )
    }

    override func themeUp() {
        super.themeUp()
        backgroundColor = theme.color.placeholder
        bottomLine.backgroundColor = theme.color.line
        topLine.backgroundColor = theme.color.line
    }

    private let topLine = UIView()
    private let bottomLine = UIView()
}

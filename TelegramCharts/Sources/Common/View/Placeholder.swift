//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

class Placeholder: View {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        topLine.frame = bounds.divided(atDistance: .pixel, from: .minYEdge).slice
        bottomLine.frame = bounds.divided(atDistance: .pixel, from: .maxYEdge).slice
    }

    private func setup() {
        addSubview(topLine)
        addSubview(bottomLine)
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

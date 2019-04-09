//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

class Placeholder: View {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    override func layoutSubviewsOnBoundsChange() {
        super.layoutSubviewsOnBoundsChange()
        topLine.frame = bounds.slice(at: .pixel, from: .minYEdge)
        bottomLine.frame = bounds.slice(at: .pixel, from: .maxYEdge)
        bringSubviewToFront(topLine)
        bringSubviewToFront(bottomLine)
    }

    private func setup() {
        addSubviews(topLine, bottomLine)
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

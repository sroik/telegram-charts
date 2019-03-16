//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

final class ChartValuesView: View {
    init(range: Range<Int>) {
        self.range = range
        super.init(frame: .zero)
        setup()
    }

    private func setup() {
        isUserInteractionEnabled = false
        backgroundColor = UIColor.yellow.withAlphaComponent(0.25)
    }

    func set(range: Range<Int>, animated: Bool = false) {}

    private var range: Range<Int>
}

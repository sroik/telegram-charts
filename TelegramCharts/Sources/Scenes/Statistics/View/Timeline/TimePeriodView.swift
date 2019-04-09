//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

protocol TimePeriodViewDelegate: AnyObject {
    func periodViewWantsToFold(_ view: TimePeriodView)
}

final class TimePeriodView: View {
    weak var delegate: TimePeriodViewDelegate?

    var viewport: Viewport {
        didSet {
            update(animated: true)
        }
    }

    init(chart: Chart, viewport: Viewport = .zeroToOne) {
        self.viewport = viewport
        self.chart = chart
        super.init(frame: .screen)
    }

    override func themeUp() {
        super.themeUp()
        label.textColor = theme.color.text
    }

    func update(animated: Bool) {}

    private let label = Label.primary(font: UIFont.semibold(size: 12))
    private let chart: Chart
}

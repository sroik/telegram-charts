//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

protocol ChartColumnsStateViewDelegate: AnyObject {
    func columnsView(_ view: ChartColumnsStateView, didEnable columns: [Column])
}

final class ChartColumnsStateView: View {
    weak var delegate: ChartColumnsStateViewDelegate?

    var enabledColumns: [Column] {
        return columns
    }

    init(sounds: SoundService, columns: [Column]) {
        self.sounds = sounds
        self.columns = columns
        super.init(frame: .screen)
        setup()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    private func setup() {
        layer.borderWidth = 1
    }

    override func themeUp() {
        super.themeUp()
    }

    private let sounds: SoundService
    private let columns: [Column]
}

//
//  Copyright © 2019 sroik. All rights reserved.
//

import Foundation

protocol ChartColumnsStateViewDelegate: AnyObject {}

final class ChartColumnsStateView: View {
    weak var delegate: ChartColumnsStateViewDelegate?

    init(columns: [Column]) {
        self.columns = columns
        super.init(frame: .zero)
    }

    private let columns: [Column]
}

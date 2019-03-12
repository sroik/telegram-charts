//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

final class ChartViewController: ViewController {
    init(chart: Chart) {
        self.chart = chart
        super.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func themeUp() {
        super.themeUp()
        view.backgroundColor = theme.color.placeholder
    }

    private let chart: Chart
}

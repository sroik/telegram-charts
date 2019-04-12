//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

final class StatisticsViewController: ViewController {
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        super.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.fill(in: view)
        theme = dependencies.settings.theme
        loadCharts()
    }

    override func themeUp() {
        super.themeUp()
        tableView.backgroundColor = theme.color.background
        tableView.visibleCells.theme(with: theme)
        chartViewControllers.theme(with: theme)
    }

    private func loadCharts() {
        charts = dependencies.charts.charts()
        chartViewControllers = charts.map(chartViewController(with:))
        tableView.reloadData()
    }

    private func chartViewController(with chart: Chart) -> ChartViewController {
        let controller = ChartViewControllerFactory.controller(
            with: chart,
            dependencies: dependencies
        )
        controller.invalidateLayout()
        controller.view.frame = CGRect(
            x: 0,
            y: 0,
            width: view.bounds.width,
            height: controller.layout.contentHeight
        )
        return controller
    }

    private lazy var tableView = UITableView.statistics()
    private var charts: [Chart] = []
    private var chartViewControllers: [ChartViewController] = []
    private let dependencies: Dependencies
}

extension StatisticsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return charts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: StatisticsTableViewCell.reusableIdentifier,
            for: indexPath
        )

        guard let statisticsCell = cell as? StatisticsTableViewCell else {
            return cell
        }

        statisticsCell.controller = chartViewControllers[safe: indexPath.row]
        statisticsCell.title = charts[safe: indexPath.row]?.title
        statisticsCell.theme = theme
        return statisticsCell
    }
}

extension StatisticsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let controller = chartViewControllers[safe: indexPath.row] else {
            assertionFailureWrapper("invalid index path")
            return 0
        }

        return controller.layout.contentHeight
    }
}

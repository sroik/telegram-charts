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
        tableView.forEachVisibleCell { (cell: StatisticsTableViewCell) in
            cell.theme = theme
        }
    }

    private func loadCharts() {
        do {
            charts = try dependencies.charts.load()
            chartViewControllers = charts.map(chartViewController(with:))
            tableView.reloadData()
        } catch {
            assertionFailureWrapper("failed to load charts")
        }
    }

    private func chartViewController(with chart: Chart) -> ChartViewController {
        let controller = ChartViewController(dependencies: dependencies, chart: chart)
        controller.view.frame = CGRect(
            x: 0,
            y: 0,
            width: view.bounds.width,
            height: height(of: controller)
        )
        return controller
    }

    private func height(of controller: ChartViewController) -> CGFloat {
        return 440 + controller.columnsViewSize.height
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

        statisticsCell.title = charts[safe: indexPath.row]?.title
        statisticsCell.theme = theme
        statisticsCell.controller = chartViewControllers[safe: indexPath.row]
        return statisticsCell
    }
}

extension StatisticsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let controller = chartViewControllers[safe: indexPath.row] else {
            assertionFailureWrapper("invalid index path")
            return 0
        }

        return height(of: controller)
    }
}

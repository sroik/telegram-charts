//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

protocol StatisticsViewControllerDelegate: AnyObject {
    func statisticsViewControllerWantsToChangeTheme(_ controller: StatisticsViewController)
}

final class StatisticsViewController: ViewController {
    weak var delegate: StatisticsViewControllerDelegate?

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
        themeButton.title = "Switch To \(theme.rotated.title) Mode"
        themeButton.theme = theme
        tableView.backgroundColor = theme.color.background
        tableView.forEachVisibleCell { (cell: StatisticsTableViewCell) in
            cell.theme = theme
        }
    }

    private func loadCharts() {
        do {
            charts = try dependencies.charts.load()
            tableView.reloadData()
        } catch {
            assertionFailureWrapper("failed to load charts")
        }
    }

    private lazy var themeButton = StatisticsTableThemeButton { [weak self] in
        if let self = self {
            self.delegate?.statisticsViewControllerWantsToChangeTheme(self)
        }
    }

    private lazy var tableView = UITableView.statistics(footer: themeButton)
    private var charts: [Chart] = []
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

        statisticsCell.title = "Followers"
        statisticsCell.theme = theme
        statisticsCell.controller = ChartViewController(chart: charts[indexPath.row])
        return statisticsCell
    }
}

extension StatisticsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 320
    }
}

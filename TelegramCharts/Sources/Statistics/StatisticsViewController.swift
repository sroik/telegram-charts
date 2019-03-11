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
        theme = dependencies.settings.settings.themeMode.theme
        loadCharts()
    }

    override func themeUp() {
        super.themeUp()
        tableView.backgroundColor = theme.color.background
        tableView.reloadData()
    }

    private func loadCharts() {
        do {
            charts = try dependencies.charts.load()
            tableView.reloadData()
        } catch {
            assertionFailureWrapper("failed to load charts")
        }
    }

    private var charts: [Chart] = []
    private let dependencies: Dependencies
    private let tableView = UITableView.statistics()
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

        statisticsCell.title = "Chart Title"
        statisticsCell.theme = theme
        return statisticsCell
    }
}

extension StatisticsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}

private extension UITableView {
    static func statistics() -> UITableView {
        let tableView = UITableView()
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        tableView.register(
            StatisticsTableViewCell.self,
            forCellReuseIdentifier: StatisticsTableViewCell.reusableIdentifier
        )
        return tableView
    }
}

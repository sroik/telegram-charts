//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

protocol ChartsListViewControllerDelegate: AnyObject {
    func chartsViewController(_ controller: ChartsListViewController, didSelect chart: Chart)
}

final class ChartsListViewController: ViewController {
    typealias Dependencies = ChartsServiceContainer

    weak var delegate: ChartsListViewControllerDelegate?

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.fill(in: view)
        tableView.register(
            UITableViewCell.self,
            forCellReuseIdentifier: UITableViewCell.reusableIdentifier
        )

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
    private let tableView = UITableView()
}

//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

final class StatisticsScene: NavigationController {
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        self.statisticsViewController = StatisticsViewController(dependencies: dependencies)
        super.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        statisticsViewController.title = "Statistics"
        viewControllers = [statisticsViewController]
        theme = dependencies.settings.theme
        updateNavigationBar()
    }

    private func updateNavigationBar() {
        statisticsViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "\(theme.rotated.title) Mode",
            style: .plain,
            target: self,
            action: #selector(themeButtonPressed)
        )
    }

    @objc private func themeButtonPressed() {
        dependencies.settings.tweak { $0.theme = $0.theme.rotated }
        theme = dependencies.settings.theme
        updateNavigationBar()
    }

    private let statisticsViewController: StatisticsViewController
    private let dependencies: Dependencies
}

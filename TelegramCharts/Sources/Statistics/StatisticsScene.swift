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
        theme = themeMode.theme
        updateNavigationBar()
    }

    private func updateNavigationBar() {
        statisticsViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: themeMode.rotated.title,
            style: .plain,
            target: self,
            action: #selector(rotateTheme)
        )
    }

    @objc private func rotateTheme() {
        dependencies.settings.tweak { $0.themeMode = $0.themeMode.rotated }
        theme = themeMode.theme
        updateNavigationBar()
    }

    private var themeMode: ThemeMode {
        return dependencies.settings.settings.themeMode
    }

    private let statisticsViewController: StatisticsViewController
    private let dependencies: Dependencies
}

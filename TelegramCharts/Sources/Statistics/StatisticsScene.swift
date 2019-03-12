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
        statisticsViewController.delegate = self
        statisticsViewController.title = "Statistics"
        viewControllers = [statisticsViewController]
        theme = dependencies.settings.theme
    }

    private let statisticsViewController: StatisticsViewController
    private let dependencies: Dependencies
}

extension StatisticsScene: StatisticsViewControllerDelegate {
    func statisticsViewControllerWantsToChangeTheme(_ controller: StatisticsViewController) {
        dependencies.settings.tweak { $0.theme = $0.theme.rotated }
        theme = dependencies.settings.theme
    }
}

//
//  Copyright © 2019 sroik. All rights reserved.
//

import Foundation

final class ChartScene: NavigationController {
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        self.listViewController = ChartsListViewController(dependencies: dependencies)
        super.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [listViewController]
    }

    private let listViewController: ChartsListViewController
    private let dependencies: Dependencies
}

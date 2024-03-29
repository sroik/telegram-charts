//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions options: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        guard !Environment.isTests else {
            return true
        }

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = statisticsScene
        window?.makeKeyAndVisible()

        return true
    }

    private lazy var dependencies = Dependencies()
    private lazy var statisticsScene = StatisticsScene(dependencies: dependencies)
}

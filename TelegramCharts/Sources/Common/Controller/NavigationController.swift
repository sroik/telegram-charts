//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
    override var prefersStatusBarHidden: Bool {
        return topViewController?.prefersStatusBarHidden ?? true
    }

    override var shouldAutorotate: Bool {
        return topViewController?.shouldAutorotate ?? false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return topViewController?.supportedInterfaceOrientations ?? [.all]
    }

    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? theme.statusBarStyle
    }

    var theme: Theme = .day {
        didSet {
            themeUp()
        }
    }

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    convenience init(root rootViewController: UIViewController) {
        self.init()
        viewControllers = [rootViewController]
    }

    @available(*, unavailable)
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.isTranslucent = false
        themeUp()
    }

    func themeUp() {
        setNeedsStatusBarAppearanceUpdate()
        children.theme(with: theme)
        viewControllers.theme(with: theme)
        view.backgroundColor = theme.color.background
        navigationBar.tintColor = theme.color.text
        navigationBar.barTintColor = theme.color.navigation
        navigationBar.titleTextAttributes = [
            .foregroundColor: theme.color.text
        ]
    }
}

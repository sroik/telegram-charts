//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

class ViewController: UIViewController, Themeable {
    override var prefersStatusBarHidden: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return Environment.isPhone ? [.portrait] : [.portrait, .portraitUpsideDown]
    }

    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return theme.statusBarStyle
    }

    var theme: Theme = .day {
        didSet {
            themeUp()
        }
    }

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        themeUp()
    }

    func themeUp() {
        setNeedsStatusBarAppearanceUpdate()
        view.backgroundColor = theme.color.background
        children.theme(with: theme)
    }
}

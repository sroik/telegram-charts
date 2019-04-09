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
            if oldValue != theme {
                themeUp()
            }
        }
    }

    var hasSuperview: Bool {
        return view.superview != nil
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

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if laidoutBounds.distance(to: view.bounds) > .layoutEpsilon {
            laidoutBounds = view.bounds
            didLayoutSubviewsOnBoundsChange()
        }
    }

    func didLayoutSubviewsOnBoundsChange() {
        /* meant to be inherited */
    }

    func themeUp() {
        setNeedsStatusBarAppearanceUpdate()
        view.backgroundColor = theme.color.background
        view.subviews.theme(with: theme)
        children.theme(with: theme)
    }

    private var laidoutBounds: CGRect = .zero
}

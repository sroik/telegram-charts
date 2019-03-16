//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

extension UILabel {
    func set(text: String?, animated: Bool, duration: TimeInterval = 0.35) {
        let transition = CATransition()
        transition.type = .fade
        transition.duration = animated ? duration : 0
        self.text = text
        layer.add(transition, forKey: nil)
    }
}

//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

extension CALayer {
    typealias KeyPath = String

    static let disabledActions = [
        KeyPath.opacity: NSNull(),
        KeyPath.bounds: NSNull(),
        KeyPath.path: NSNull(),
        KeyPath.position: NSNull(),
        KeyPath.transform: NSNull(),
        KeyPath.backgroundColor: NSNull()
    ]

    var presentedYScale: CGFloat {
        return (presentedValue(for: .yScale) as? CGFloat) ?? 1
    }

    static func performWithoutAnimation(_ animationlessBlock: () -> Void) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        animationlessBlock()
        CATransaction.commit()
    }

    func addSublayerIfNeeded(_ child: CALayer) {
        if child.superlayer != self {
            addSublayer(child)
        }
    }

    func removeFromSuperlayerIfNeeded() {
        if superlayer != nil {
            removeFromSuperlayer()
        }
    }

    func basicAnimation(for keyPath: KeyPath) -> CABasicAnimation? {
        return animation(forKey: keyPath) as? CABasicAnimation
    }

    func presentedValue(for keyPath: KeyPath) -> Any? {
        if animation(forKey: keyPath) == nil {
            return value(forKeyPath: keyPath)
        }

        return presentation()?.value(forKeyPath: keyPath) ?? value(forKeyPath: keyPath)
    }

    func disableActions() {
        actions = CALayer.disabledActions
    }
}

extension CALayer.KeyPath {
    static let opacity = "opacity"
    static let position = "position"
    static let bounds = "bounds"
    static let path = "path"
    static let yScale = "transform.scale.y"
    static let xTranslation = "transform.translation.x"
    static let transform = "transform"
    static let backgroundColor = "backgroundColor"
    static let strokeStart = "strokeStart"
    static let strokeEnd = "strokeEnd"
    static let string = "string"
}

//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

struct ShelfLayout {
    let verticalSpacing: CGFloat
    let horizontalSpacing: CGFloat
    let itemHeight: CGFloat
    let insets: UIEdgeInsets
}

protocol Sizeable {
    var size: CGSize { get }
}

extension ShelfLayout {
    static let `default` = ShelfLayout(
        verticalSpacing: 10,
        horizontalSpacing: 10,
        itemHeight: 30,
        insets: UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
    )

    func size(of items: [Sizeable], fitting width: CGFloat) -> CGSize {
        let maxY = frames(of: items, fitting: width).last?.maxY ?? insets.top
        return CGSize(width: width, height: maxY + insets.bottom)
    }

    func frames(of items: [Sizeable], fitting width: CGFloat) -> [CGRect] {
        var frames: [CGRect] = []
        var origin = CGPoint(x: insets.left, y: insets.top)
        let maxAllowedX = width - insets.right

        items.lazy.map { $0.size }.forEach { size in
            let minX = origin.x
            let maxX = minX + size.width
            let fits = maxX < maxAllowedX

            origin = CGPoint(
                x: (fits ? maxX : insets.left + size.width) + horizontalSpacing,
                y: fits ? origin.y : origin.y + itemHeight + verticalSpacing
            )

            frames.append(CGRect(
                x: fits ? minX : insets.left,
                y: origin.y,
                width: size.width,
                height: itemHeight
            ))
        }

        return frames
    }
}

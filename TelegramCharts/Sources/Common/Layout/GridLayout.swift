//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

struct GridLayout {
    let itemSide: ItemSide
    let itemsNumber: Int
    let insets: UIEdgeInsets
    let direction: Direction
}

extension GridLayout {
    enum Direction {
        case horizontal
        case vertical
    }

    enum ItemSide {
        case flexible
        case fixed(CGFloat)
    }
}

extension GridLayout {
    func itemFrame(at index: Int, in rect: CGRect) -> CGRect {
        let side = self.itemSide(in: rect)
        let spacing = self.spacing(in: rect)

        switch direction {
        case .horizontal:
            return CGRect(
                x: rect.minX + insets.left + CGFloat(index) * (side + spacing),
                y: rect.minY + insets.top,
                width: side,
                height: rect.height - insets.vertical
            )
        case .vertical:
            return CGRect(
                x: rect.minX + insets.left,
                y: rect.minY + insets.top + CGFloat(index) * (side + spacing),
                width: rect.width - insets.horizontal,
                height: side
            )
        }
    }

    func spacing(in rect: CGRect) -> CGFloat {
        switch itemSide {
        case let .fixed(itemSide):
            let itemsSize = CGFloat(itemsNumber) * itemSide
            let freeSpace = rect.height - insets.vertical - itemsSize
            return freeSpace / CGFloat(itemsNumber - 1)
        case .flexible:
            return 0
        }
    }

    func itemSide(in rect: CGRect) -> CGFloat {
        switch itemSide {
        case .flexible:
            return (directedSide(of: rect) - directedInsets) / CGFloat(itemsNumber)
        case let .fixed(side):
            return side
        }
    }

    private func directedSide(of rect: CGRect) -> CGFloat {
        switch direction {
        case .horizontal: return rect.width
        case .vertical: return rect.height
        }
    }

    private var directedInsets: CGFloat {
        switch direction {
        case .horizontal: return insets.horizontal
        case .vertical: return insets.vertical
        }
    }
}

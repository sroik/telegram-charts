//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

struct ChartGridLayout {
    let itemHeight: CGFloat
    let minimumSpacing: CGFloat
}

extension ChartGridLayout {
    static let `default` = ChartGridLayout(itemHeight: 20, minimumSpacing: 30)

    func itemFrame(at index: Int, in rect: CGRect) -> CGRect {
        return CGRect(
            x: rect.minX,
            y: rect.minY + CGFloat(index) * (itemHeight + spacing(in: rect)),
            width: rect.width,
            height: itemHeight
        )
    }

    func spacing(in rect: CGRect) -> CGFloat {
        let items = itemsNumber(in: rect)
        let itemsHeight = CGFloat(items) * itemHeight
        let freeSpace = rect.height - itemsHeight
        return freeSpace / CGFloat(items - 1)
    }

    func itemsNumber(in rect: CGRect) -> Int {
        /* const 1 means that top item has no spacing  */
        let freeSpace = rect.height - itemHeight
        let cells = Int(freeSpace / (minimumSpacing + itemHeight))
        return cells + 1
    }
}

//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

struct ChartGridLayout {
    let itemHeight: CGFloat
    let itemsNumber: Int
    let insets: UIEdgeInsets
}

extension ChartGridLayout {
    static let values = ChartGridLayout(
        itemHeight: 20,
        itemsNumber: 6,
        insets: .zero
    )

    func itemFrame(at index: Int, in rect: CGRect) -> CGRect {
        return CGRect(
            x: rect.minX + insets.left,
            y: rect.minY + insets.top + CGFloat(index) * (itemHeight + spacing(in: rect)),
            width: rect.width - insets.horizontal,
            height: itemHeight
        )
    }

    func spacing(in rect: CGRect) -> CGFloat {
        let itemsHeight = CGFloat(itemsNumber) * itemHeight
        let freeSpace = rect.height - insets.vertical - itemsHeight
        return freeSpace / CGFloat(itemsNumber - 1)
    }
}

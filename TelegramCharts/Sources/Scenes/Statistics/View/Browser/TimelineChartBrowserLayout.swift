//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

struct TimelineChartBrowserLayout {
    var lineWidth: CGFloat
    var isLineOnTop: Bool
    var cardTopOffset: CGFloat
    var insets: UIEdgeInsets
    var timelineHeight: CGFloat

    init(
        lineWidth: CGFloat = .pixel,
        isOnLineTop: Bool = false,
        cardTopOffset: CGFloat = 0,
        timelineHeight: CGFloat = 25,
        insets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    ) {
        self.lineWidth = lineWidth
        self.isLineOnTop = isOnLineTop
        self.insets = insets
        self.timelineHeight = timelineHeight
        self.cardTopOffset = cardTopOffset
    }

    func timelineFrame(in rect: CGRect) -> CGRect {
        return insets.inset(rect).slice(at: timelineHeight, from: .maxYEdge)
    }

    func gridFrame(in rect: CGRect) -> CGRect {
        return insets.inset(rect).remainder(at: timelineHeight, from: .maxYEdge)
    }

    func chartContainerFrame(in rect: CGRect) -> CGRect {
        return rect.remainder(at: timelineHeight, from: .maxYEdge)
    }

    func chartFrame(in rect: CGRect) -> CGRect {
        let containerBounds = chartContainerFrame(in: rect).originless
        return containerBounds.inset(by: insets)
    }

    func cardFrame(size: CGSize, in rect: CGRect, lineCenter: CGFloat) -> CGRect {
        let limits = rect.inset(by: insets).inset(left: 35)
        let leftSpace = lineCenter - limits.minX
        let rightSpace = limits.maxX - lineCenter
        if leftSpace > rightSpace {
            return CGRect(
                maxX: lineCenter - 15,
                y: cardTopOffset,
                size: size
            ).limited(with: limits)
        } else {
            return CGRect(
                x: lineCenter + 15,
                y: cardTopOffset,
                size: size
            ).limited(with: limits)
        }
    }

    func lineFrame(in rect: CGRect, centerX: CGFloat) -> CGRect {
        return CGRect(
            midX: centerX,
            y: rect.minY,
            width: lineWidth,
            height: rect.height
        )
    }
}

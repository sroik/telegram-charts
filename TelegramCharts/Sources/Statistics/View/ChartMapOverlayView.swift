//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

protocol ChartMapOverlayViewDelegate: AnyObject {
    func mapView(_ view: ChartMapOverlayView, didChageRange range: Range<CGFloat>)
}

final class ChartMapOverlayView: View {
    weak var delegate: ChartMapOverlayViewDelegate?
    var range: Range<CGFloat> = Range(min: 0.65, max: 0.85)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layoutViewport()
    }

    private func setup() {
        addSubviews(viewportView, leftSpaceView, rightSpaceView)
    }

    private func layoutViewport() {
        viewportView.frame = CGRect(
            x: bounds.width * range.min,
            y: -viewportView.lineWidth,
            width: bounds.width * range.max - bounds.width * range.min,
            height: bounds.height + viewportView.lineWidth * 2
        )

        leftSpaceView.frame = CGRect(
            x: 0,
            y: 0,
            width: viewportView.frame.minX,
            height: bounds.height
        )

        rightSpaceView.frame = CGRect(
            x: viewportView.frame.maxX,
            y: 0,
            width: bounds.width - viewportView.frame.maxX,
            height: bounds.height
        )
    }

    override func themeUp() {
        super.themeUp()
        [leftSpaceView, rightSpaceView].forEach { view in
            view.backgroundColor = theme.color.background.withAlphaComponent(0.5)
        }
    }

    private let viewportView = ChartMapViewportView(frame: .screen)
    private let leftSpaceView = UIView()
    private let rightSpaceView = UIView()
}

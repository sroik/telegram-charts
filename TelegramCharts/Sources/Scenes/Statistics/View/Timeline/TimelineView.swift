//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

final class TimelineView: ViewportView {
    var minimumSpacing: CGFloat = 50.0 {
        didSet {
            update(animated: true)
        }
    }

    init(chart: Chart) {
        self.chart = chart
        super.init()
        setup()
    }

    override func themeUp() {
        super.themeUp()
        backgroundColor = theme.color.placeholder
        line.backgroundColor = theme.color.gridLine
        rowView.theme = theme
    }

    override func layoutSubviewsOnBoundsChange() {
        super.layoutSubviewsOnBoundsChange()
        line.frame = bounds.slice(at: .pixel, from: .minYEdge)
        update(animated: true)
    }

    override func adaptViewport() {
        super.adaptViewport()
        rowView.visibleRect = visibleRect
    }

    override func display() {
        super.display()
        update(animated: true)
    }

    func update(animated: Bool) {
        if !contentFrame.isEmpty, fitLabelsNumber != rowView.count {
            updateRowView(animated: animated)
        }
    }

    func updateRowView(animated: Bool) {
        let oldRowView = rowView
        oldRowView.layer.removeAllAnimations()

        rowView = TimelineRowView(
            itemWidth: minimumSpacing,
            timestamps: fitTimestamps,
            format: chart.expandable ? "d MMM" : "HH:mm"
        )

        rowView.fill(in: contentView)
        rowView.theme = theme
        rowView.visibleRect = visibleRect

        switch rowView.count.compare(with: oldRowView.count) {
        case .orderedDescending where animated:
            rowView.fadeIn(animated: animated, then: oldRowView.removeFromSuperview)
        case .orderedAscending where animated:
            oldRowView.removeFromSuperview(animated: animated)
        default:
            oldRowView.removeFromSuperview()
        }
    }

    private var fitTimestamps: [Timestamp] {
        guard !contentFrame.isEmpty, fitLabelsNumber > 1 else {
            return []
        }

        let spacing = contentSize.width / CGFloat(fitLabelsNumber - 1)
        let stamps: [Timestamp] = (0 ..< fitLabelsNumber).compactMap { index in
            let position = CGFloat(index) * spacing / contentSize.width
            return chart.timestamps.element(nearestTo: position)
        }

        return stamps
    }

    private func setup() {
        isUserInteractionEnabled = false
        displayLink.fps = 4
        addSubview(line)
    }

    private var fitLabelsNumber: Int {
        let fitNumber = Int(contentSize.width / minimumSpacing)
        let maxNumber = chart.timestamps.count
        let clamped = min(fitNumber, maxNumber) - 1
        return (clamped.nearestPowerOfTwo ?? 0) + 1
    }

    private var rowView = TimelineRowView(itemWidth: 0, timestamps: [], format: "")
    private let chart: Chart
    private let line = UIView()
}

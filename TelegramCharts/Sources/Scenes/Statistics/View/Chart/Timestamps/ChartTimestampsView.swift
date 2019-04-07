//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

final class ChartTimestampsView: View {
    var minimumSpacing: CGFloat = 60.0 {
        didSet {
            update(animated: true)
        }
    }

    init(timestamps: [Timestamp]) {
        self.timestamps = timestamps
        super.init(frame: .screen)
        setup()
    }

    override func layoutSubviewsOnBoundsChange() {
        super.layoutSubviewsOnBoundsChange()
        line.frame = bounds.slice(at: .pixel, from: .minYEdge)
        displayLink.needsToDisplay = true
    }

    override func themeUp() {
        super.themeUp()
        backgroundColor = theme.color.placeholder
        line.backgroundColor = theme.color.details.withAlphaComponent(0.35)
        rowView.theme = theme
    }

    func update(animated: Bool) {
        if !bounds.isEmpty, fitLabelsNumber != rowView.count {
            updateRowView(animated: animated)
        }
    }

    private func updateRowView(animated: Bool) {
        let oldRowView = rowView
        rowView = ChartTimestampsRowView(itemWidth: minimumSpacing, timestamps: fitTimestamps)
        rowView.theme = theme
        rowView.fill(in: self)

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
        guard !bounds.isEmpty else {
            return []
        }

        let spacing = bounds.width / CGFloat(fitLabelsNumber)
        let indices = (0 ..< fitLabelsNumber)
        let stamps: [Timestamp] = indices.compactMap { index in
            let position = CGFloat(index + 1) * spacing / bounds.width
            return timestamps.element(nearestTo: position, strategy: .ceil)
        }

        return stamps
    }

    private func setup() {
        addSubview(line)

        displayLink.start { [weak self] _ in
            self?.update(animated: true)
        }
    }

    private var fitLabelsNumber: Int {
        let fitNumber = Int(bounds.width / minimumSpacing)
        let maxNumber = timestamps.count
        return min(fitNumber, maxNumber).nearestPowerOfTwo ?? 1
    }

    private let displayLink = DisplayLink(fps: 12)
    private var rowView = ChartTimestampsRowView(itemWidth: 0, timestamps: [])
    private let timestamps: [Timestamp]
    private let line = UIView()
}

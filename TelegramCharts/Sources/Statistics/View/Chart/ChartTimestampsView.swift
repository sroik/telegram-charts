//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

final class ChartTimestampsView: View {
    var minimumSpacing: CGFloat = 50.0 {
        didSet {
            updateSpacing(animated: true)
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
        updateSpacing(animated: true)
    }

    override func themeUp() {
        super.themeUp()
        backgroundColor = theme.color.placeholder
        line.backgroundColor = theme.color.line
        labels.values.forEach { $0.textColor = theme.color.details }
    }

    func updateSpacing(animated: Bool) {
        guard !bounds.isEmpty else {
            return
        }

        switch labelsNumber.compare(with: fitLabelsNumber) {
        case .orderedAscending:
            recursiveBisect(animated: animated)
            updateFrames()
        case .orderedDescending where labelsNumber > 1:
            recursiveJoin(animated: false)
            updateFrames()
        case .orderedSame, .orderedDescending:
            updateFrames()
        }
    }

    private func recursiveBisect(animated: Bool) {
        while labelsNumber < fitLabelsNumber {
            bisect(animated: animated)
        }
    }

    private func recursiveJoin(animated: Bool) {
        while labelsNumber > fitLabelsNumber && labelsNumber > 1 {
            join(animated: animated)
        }
    }

    private func bisect(animated: Bool) {
        labelsNumber *= 2
        labels = labels.mapKeys { $0 * 2 + 1 }

        (0 ..< labelsNumber).forEach { index in
            guard labels[index] == nil else {
                return
            }

            addLabel(at: index, animated: animated)
        }
    }

    private func join(animated: Bool) {
        (0 ..< labelsNumber).filter { $0.isEven }.forEach { index in
            removeLabel(at: index, animated: animated)
        }

        labelsNumber /= 2
        labels = labels.mapKeys { $0 / 2 }
    }

    private func updateFrames() {
        labels.forEach { index, label in
            label.frame = labelFrame(at: index)
        }
    }

    private func removeLabel(at index: Index, animated: Bool) {
        guard let label = labels[index] else {
            return
        }

        labels[index] = nil
        label.removeFromSuperview(animated: animated)
    }

    private func addLabel(at index: Index, animated: Bool) {
        guard labels[index] == nil else {
            return
        }

        let label = buildLabel(at: index)
        addSubview(label, animated: animated)
        labels[index] = label
    }

    private func buildLabel(at index: Index) -> Label {
        guard let timestamp = timestamp(at: index) else {
            assertionFailureWrapper("invalid timestamp index")
            return Label()
        }

        let label = buildLabel(for: timestamp)
        label.frame = labelFrame(at: index)
        return label
    }

    private func buildLabel(for timestamp: Timestamp) -> Label {
        return Label.details(
            text: Date(timestamp: timestamp).monthDayString,
            color: theme.color.details,
            alignment: .right
        )
    }

    private func timestamp(at index: Index) -> Timestamp? {
        guard !bounds.isEmpty else {
            return timestamps.last
        }

        let position = CGFloat(index + 1) * spacing / bounds.width
        return timestamps.element(nearestTo: position, strategy: .ceil)
    }

    private func labelFrame(at index: Index) -> CGRect {
        return CGRect(
            x: CGFloat(index) * spacing,
            y: 0,
            width: spacing,
            height: bounds.height
        )
    }

    private func setup() {
        addSubview(line)
    }

    private var fitLabelsNumber: Int {
        let fitNumber = Int(bounds.width / minimumSpacing)
        let maxNumber = timestamps.count
        return min(fitNumber, maxNumber).nearestPowerOfTwo ?? 1
    }

    private var spacing: CGFloat {
        return bounds.width / CGFloat(labelsNumber)
    }

    private var labelsNumber: Int = 1
    private var labels: [Index: Label] = [:]
    private let timestamps: [Timestamp]
    private let line = UIView()
}

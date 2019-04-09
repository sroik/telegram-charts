//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

protocol TimePeriodViewDelegate: AnyObject {
    func periodViewWantsToFold(_ view: TimePeriodView)
}

final class TimePeriodView: View {
    weak var delegate: TimePeriodViewDelegate?

    var viewport: Viewport {
        didSet {
            update()
        }
    }

    init(chart: Chart, viewport: Viewport = .zeroToOne) {
        self.viewport = viewport
        self.chart = chart
        super.init(frame: .screen)
        setup()
    }

    override func themeUp() {
        super.themeUp()
        label.textColor = theme.color.text
        label.backgroundColor = theme.color.placeholder
        button.backgroundColor = theme.color.placeholder
        button.tintColor = theme.color.tint
        button.setTitleColor(theme.color.tint, for: .normal)
    }

    override func layoutSubviewsOnBoundsChange() {
        super.layoutSubviewsOnBoundsChange()
        update()
    }

    func update() {
        label.text = isSingleDay ? singleDayTitle : differentDaysTitle
        button.isHidden = chart.expandable
        layout()
    }

    func layout() {
        guard button.isVisible else {
            label.frame = bounds
            return
        }

        let buttonWidth = button.intrinsicContentSize.width
        button.frame = bounds.slice(at: buttonWidth + spacing, from: .minXEdge)

        let labelWidth = label.intrinsicContentSize.width
        let labelLimits = bounds.remainder(at: button.frame.maxX + spacing, from: .minXEdge)
        let labelFrame = CGRect(midX: bounds.midX, width: labelWidth, height: bounds.height)
        label.frame = labelFrame.limited(with: labelLimits)
    }

    private func setup() {
        button.addTarget(self, action: #selector(fold), for: .touchUpInside)
        addSubviews(label, button)
        update()
    }

    @objc private func fold() {
        delegate?.periodViewWantsToFold(self)
    }

    private var singleDayTitle: String {
        return midDate.string(format: "EEEE, d MMM yyyy")
    }

    private var differentDaysTitle: String {
        let format = "d MMM yyyy"
        let min = midDate.string(format: format)
        let max = maxDate.string(format: format)
        return "\(min) - \(max)"
    }

    private var isSingleDay: Bool {
        return midDate.isSameDay(as: maxDate)
    }

    private var midDate: Date {
        return Date(timestamp: minTimestamp)
    }

    private var maxDate: Date {
        return Date(timestamp: maxTimestamp)
    }

    private var minTimestamp: Timestamp {
        return chart.timestamps.element(nearestTo: viewport.min, strategy: .floor) ?? 0
    }

    private var maxTimestamp: Timestamp {
        return chart.timestamps.element(nearestTo: viewport.max, strategy: .ceil) ?? 0
    }

    private let chart: Chart
    private let spacing: CGFloat = 5
    private lazy var label = Label.primary(font: UIFont.semibold(size: 13))
    private lazy var button = Button.fold(spacing: spacing)
}

private extension Button {
    static func fold(spacing: CGFloat) -> Button {
        return Button.primary(
            title: "Zoom Out",
            image: Image.leftArrow,
            font: UIFont.regular(size: 12),
            titleInsets: UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: 0),
            imageInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: spacing)
        )
    }
}

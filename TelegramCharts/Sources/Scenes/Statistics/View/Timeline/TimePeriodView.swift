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

    var isSingleDay: Bool {
        return timePeriod.isSingleDay
    }

    var timePeriod: Range<Date> {
        return chart.timePeriod(in: viewport)
    }

    init(chart: Chart, viewport: Viewport = .zeroToOne) {
        self.viewport = viewport
        self.chart = chart
        super.init(frame: .screen)
        setup()
    }

    override func themeUp() {
        super.themeUp()
        backgroundColor = theme.color.placeholder
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
        label.set(text: isSingleDay ? singleDayTitle : differentDaysTitle)
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
        return singleDayFormatter.string(from: timePeriod.mid)
    }

    private var differentDaysTitle: String {
        let period = timePeriod
        let min = differentDaysFormatter.string(from: period.min)
        let max = differentDaysFormatter.string(from: period.max)
        return "\(min) - \(max)"
    }

    private let chart: Chart
    private let spacing: CGFloat = 5
    private let singleDayFormatter = DateFormatter(format: "EEEE, d MMM yyyy")
    private let differentDaysFormatter = DateFormatter(format: "d MMM yyyy")
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

private extension Range where T == Date {
    var isSingleDay: Bool {
        return min.isSameDay(as: max)
    }

    var isAlmostSingleDay: Bool {
        /* Just to make it look more pretty */
        return (min + .hour).isSameDay(as: max - .hour)
    }

    var mid: Date {
        let minInterval = min.timeIntervalSince1970
        let maxInterval = max.timeIntervalSince1970
        return Date(timeIntervalSince1970: (minInterval + maxInterval) / 2)
    }
}

private extension Chart {
    func timePeriod(in viewport: Viewport) -> Range<Date> {
        let min = timestamps.element(nearestTo: viewport.min, rule: .up) ?? 0
        let max = timestamps.element(nearestTo: viewport.max, rule: .down) ?? 0
        return Range(
            min: Date(timestamp: min),
            max: Date(timestamp: max)
        )
    }
}

//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

struct ChartGridViewCellState {
    var lineWidth: CGFloat
    var leftValue: Int?
    var rightValue: Int?
    var leftColor: UIColor?
    var rightColor: UIColor?

    init(
        lineWidth: CGFloat = .pixel,
        leftValue: Int? = nil,
        rightValue: Int? = nil,
        leftColor: UIColor? = nil,
        rightColor: UIColor? = nil
    ) {
        self.lineWidth = lineWidth
        self.leftValue = leftValue
        self.rightValue = rightValue
        self.leftColor = leftColor
        self.rightColor = rightColor
    }
}

final class ChartGridViewCell: View {
    var state: ChartGridViewCellState {
        didSet {
            updateState()
        }
    }

    init(state: ChartGridViewCellState = ChartGridViewCellState()) {
        self.state = state
        super.init(frame: .screen)
        setup()
    }

    override func layoutSubviewsOnBoundsChange() {
        super.layoutSubviewsOnBoundsChange()
        leftLabel.frame = bounds.slice(at: bounds.midX, from: .minXEdge)
        rightLabel.frame = bounds.remainder(at: bounds.midX, from: .minXEdge)
        updateState()
    }

    override func themeUp() {
        super.themeUp()
        line.backgroundColor = theme.color.gridLine
        updateState()
    }

    func updateState() {
        leftLabel.textColor = state.leftColor ?? theme.color.details
        rightLabel.textColor = state.rightColor ?? theme.color.details
        leftLabel.text = state.leftValue.flatMap { String(roundedValue: $0) }
        rightLabel.text = state.rightValue.flatMap { String(roundedValue: $0) }
        leftLabel.isHidden = state.leftValue == nil
        rightLabel.isHidden = state.rightValue == nil
        line.frame = bounds.slice(at: state.lineWidth, from: .maxYEdge)
    }

    private func setup() {
        addSubviews(line, leftLabel, rightLabel)
        updateState()
    }

    private let leftLabel = Label.details(alignment: .left)
    private let rightLabel = Label.details(alignment: .right)
    private let line = UIView()
}

extension ChartGridViewCell: Cloneable {
    func clone() -> ChartGridViewCell {
        return ChartGridViewCell(state: state)
    }
}

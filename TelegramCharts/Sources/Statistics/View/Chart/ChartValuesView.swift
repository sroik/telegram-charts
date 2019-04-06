//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

final class ChartValuesView: View {
    init(layout: ChartGridLayout = .default, range: Range<Int>) {
        self.range = range
        self.layout = layout
        super.init(frame: .zero)
        setup()
    }

    override func layoutSubviewsOnBoundsChange() {
        super.layoutSubviewsOnBoundsChange()
        rebuildLabels()
    }

    override func themeUp() {
        super.themeUp()
        labels.forEach { $0.textColor = theme.color.details }
    }

    func set(range: Range<Int>, animated: Bool = false) {
        guard self.range != range else {
            return
        }
        
        self.range = range
        updateValues(animated: true)
    }

    private func updateValues(animated: Bool) {
        labels.enumerated().forEach { index, label in
            label.set(text: labelText(at: index), animated: animated)
        }
    }

    private func rebuildLabels() {
        guard !bounds.isEmpty else {
            return
        }

        labels.forEach { $0.removeFromSuperview() }
        labels.removeAll()

        (0 ..< labelsNumber).forEach { index in
            let label = buildLabel(at: index)
            labels.append(label)
            addSubview(label)
        }
    }

    private func buildLabel(at index: Int) -> Label {
        let label = Label.details(alignment: .left)
        label.text = labelText(at: index)
        label.textColor = theme.color.details
        label.frame = layout.itemFrame(at: index, in: bounds)
        return label
    }

    private func labelText(at index: Int) -> String {
        return String(columnValue: labelValue(at: index))
    }

    private func labelValue(at index: Int) -> Int {
        let maxY = layout.itemFrame(at: index, in: bounds).maxY
        let position = 1 - (maxY / bounds.height)
        return range.value(at: position)
    }

    private func setup() {
        isUserInteractionEnabled = false
        rebuildLabels()
    }

    private var labelsNumber: Int {
        return layout.itemsNumber(in: bounds)
    }

    private let layout: ChartGridLayout
    private var range: Range<Int>
    private var labels: [Label] = []
}

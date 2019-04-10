//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

struct BarColumnValue: Hashable {
    var id: String
    var value: Int
    var color: CGColor?
}

class StackedBarColumnLayer: Layer {
    let values: [BarColumnValue]
    let valueLayers: [CALayer]

    init(values: [BarColumnValue]) {
        self.values = values
        self.valueLayers = values.map(CALayer.init(value:))
        self.enabledIds = Set(values.map { $0.id })
        super.init()
        setup()
    }

    override init(layer: Any) {
        values = []
        valueLayers = []
        enabledIds = []
        super.init(layer: layer)
    }

    required convenience init?(coder aDecoder: NSCoder) {
        self.init(values: [])
    }

    override func layoutSublayersOnBoundsChange() {
        super.layoutSublayersOnBoundsChange()
        draw(animated: false)
    }

    override func themeUp() {
        super.themeUp()
        backgroundColor = theme.color.placeholder.cgColor
    }

    func enable(values: [String], animated: Bool) {
        enabledIds = Set(values)
        draw(animated: animated)
    }

    func set(range: Range<Int>, animated: Bool) {
        if self.range != range {
            self.range = range
            draw(animated: animated)
        }
    }

    func draw(animated: Bool) {
        guard !bounds.isEmpty, !range.isEmpty else {
            return
        }

        let ratio = CGFloat(stackedValue) / CGFloat(range.size)
        print(ratio)
//        valueLayers.first?.set(frame: CGRect(
//            maxY: bounds.height,
//            width: bounds.width,
//            height: bounds.height * ratio
//        ))
    }

    private func setup() {
        isOpaque = true
//        valueLayers.reversed().forEach(addSublayer)
    }

    private var stackedValue: Int {
        return values
            .filter { enabledIds.contains($0.id) }
            .reduce(0) { $0 + $1.value }
    }

    private var enabledIds: Set<String>
    private var range: Range<Int> = .zero
}

extension BarColumnValue {
    static var empty: BarColumnValue {
        return BarColumnValue(id: "", value: 0, color: nil)
    }
}

extension CALayer {
    convenience init(value: BarColumnValue) {
        self.init()
        backgroundColor = value.color
        isOpaque = true
    }
}

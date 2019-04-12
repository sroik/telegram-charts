//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

extension Int {
    static let billion: Int = 1_000_000_000
    static let million: Int = 1_000_000
    static let thousand: Int = 1000

    var billions: CGFloat {
        return CGFloat(self) / CGFloat(Int.billion)
    }

    var millions: CGFloat {
        return CGFloat(self) / CGFloat(Int.million)
    }

    var thousands: CGFloat {
        return CGFloat(self) / CGFloat(Int.thousand)
    }
}

extension String {
    var basename: String {
        return components(separatedBy: "/").last ?? ""
    }

    var ext: String {
        let comps = components(separatedBy: ".")
        let last = comps.count > 1 ? comps.last : nil
        return last ?? ""
    }

    init(roundedValue value: Int) {
        switch abs(value) {
        case Int.billion ... Int.max:
            self.init(format: "%.1fB", value.billions)
        case Int.million ... Int.billion:
            self.init(format: "%.1fM", value.millions)
        case Int.thousand ... Int.million:
            self.init(format: "%.1fK", value.thousands)
        default:
            self.init(value)
        }
    }

    init(value: Int) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        let string = formatter.string(for: NSNumber(value: value))
        self = string ?? String(value)
    }

    init(percent: CGFloat) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.formatWidth = 3
        let number = NSNumber(value: Double(percent))
        let string = formatter.string(for: number)
        self = string ?? String(Int(percent * 100))
    }
}

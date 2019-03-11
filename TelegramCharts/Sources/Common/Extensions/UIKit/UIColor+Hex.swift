//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

typealias HexColor = String

extension UIColor {
    convenience init?(hex: HexColor) {
        let string: String = hex
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .uppercased()
            .hexless()
        
        let divisor: CGFloat = 255
        var value: UInt32 = 0
        Scanner(string: string).scanHexInt32(&value)
        
        switch string.count {
        case 6:
            self.init(
                red: CGFloat((value & 0xFF0000) >> 16) / divisor,
                green: CGFloat((value & 0x00FF00) >> 8) / divisor,
                blue: CGFloat(value & 0x0000FF) / divisor,
                alpha: 1.0
            )
        case 8:
            self.init(
                red: CGFloat((value & 0xFF000000) >> 24) / divisor,
                green: CGFloat((value & 0x00FF0000) >> 16) / divisor,
                blue: CGFloat((value & 0x0000FF00) >> 8) / divisor,
                alpha: CGFloat(value & 0x000000FF) / divisor
            )
        default:
            assertionWrapperFailure("incorrect hex format")
            return nil
        }
    }
    
    func isEqual(
        to color: UIColor?,
        withThreshold threshold: Double = .ulpOfOne
    ) -> Bool {
        guard let color = color else {
            return false
        }
        
        var r1: CGFloat = 0
        var g1: CGFloat = 0
        var b1: CGFloat = 0
        var a1: CGFloat = 0
        var r2: CGFloat = 0
        var g2: CGFloat = 0
        var b2: CGFloat = 0
        var a2: CGFloat = 0
        getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        color.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
        
        let distance = sqrt((r1 - r2) ** 2 + (g1 - g2) ** 2 + (b1 - b2) ** 2 + (a1 - a2) ** 2)
        /* It's because of √(1^2 + 1^2 + 1^2 + 1^2) */
        let maxPossibleDistance = 2.0
        let allowedDistance = maxPossibleDistance * threshold
        let isEqual = Double(distance) < allowedDistance
        return isEqual
    }
}

private extension String {
    func hexless() -> String {
        return hasPrefix("#") ? String(dropFirst()) : self
    }
}

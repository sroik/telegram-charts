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
            assertionFailure("incorrect hex format")
            return nil
        }
    }
}

private extension String {
    func hexless() -> String {
        return hasPrefix("#") ? String(dropFirst()) : self
    }
}

//
//  Copyright © 2019 sroik. All rights reserved.
//

import Foundation

extension Date {
    var monthDayString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: self)
    }

    var yearString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter.string(from: self)
    }

    init(timestamp: Timestamp) {
        let unix = TimeInterval(timestamp) / 1000.0
        self.init(timeIntervalSince1970: unix)
    }
}

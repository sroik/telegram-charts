//
//  Copyright © 2019 sroik. All rights reserved.
//

import Foundation

extension Date {
    func string(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }

    func isSameDay(as date: Date) -> Bool {
        return Calendar.current.isDate(self, inSameDayAs: date)
    }

    init(timestamp: Timestamp) {
        let unix = TimeInterval(timestamp) / 1000.0
        self.init(timeIntervalSince1970: unix)
    }
}

extension TimeInterval {
    static var day: TimeInterval {
        return 24 * hour
    }

    static var hour: TimeInterval {
        return 60 * minute
    }

    static var minute: TimeInterval {
        return 60
    }
}

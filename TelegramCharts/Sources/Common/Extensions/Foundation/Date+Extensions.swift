//
//  Copyright © 2019 sroik. All rights reserved.
//

import Foundation

extension Date {
    var nearestHour: Date {
        return rounded(by: .hour)
    }

    func rounded(by interval: TimeInterval) -> Date {
        let count = (timeIntervalSinceReferenceDate / interval).rounded(.toNearestOrEven)
        let stamp = count * interval
        return Date(timeIntervalSinceReferenceDate: stamp)
    }

    func string(format: String) -> String {
        return DateFormatter(format: format).string(from: self)
    }

    func isSameDay(as date: Date) -> Bool {
        return Calendar.local.isDate(self, inSameDayAs: date)
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

extension DateFormatter {
    convenience init(format: String) {
        self.init()
        dateFormat = format
        timeZone = .utc
    }
}

extension Calendar {
    static var local: Calendar = {
        var calendar = Calendar.current
        calendar.timeZone = .utc
        return calendar
    }()
}

/*
 * I'm not sure I need this logic.
 * Just want the charts to look pretty
 */
extension TimeZone {
    static var utc: TimeZone = {
        guard let utc = TimeZone(identifier: "UTC") else {
            assertionFailureWrapper("failed to init utc time zone")
            return .current
        }

        return utc
    }()
}

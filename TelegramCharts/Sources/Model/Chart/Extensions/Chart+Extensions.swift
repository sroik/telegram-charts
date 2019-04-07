//
//  Copyright © 2019 sroik. All rights reserved.
//

import Foundation

typealias Timestamp = Int

extension Chart {
    var timestamps: [Timestamp] {
        guard let column = timestampsColumn else {
            assertionFailureWrapper("chart has no timestamps column")
            return []
        }

        return column.values
    }

    var timestampsColumn: Column? {
        return columns.first { $0.type.isTimestamps }
    }

    var drawableColumns: [Column] {
        return columns.filter { $0.type.isDrawable }
    }
}

extension Chart {
    static func charts(at url: URL) throws -> [Chart] {
        let data = try Data(contentsOf: url)
        return try charts(with: data)
    }

    static func charts(with data: Data) throws -> [Chart] {
        let chartsData = try JSONDecoder().decode([ChartData].self, from: data)
        return chartsData.compactMap { Chart(chartData: $0) }
    }

    init?(chartData: ChartData) {
        let columns: [Column] = chartData.columns.compactMap { data in
            guard let label = data.first?.stringValue else {
                assertionFailureWrapper("column has no label")
                return nil
            }

            guard let type = chartData.types[label] else {
                assertionFailureWrapper("chart has no type for given column")
                return nil
            }

            let headlessData = data.dropFirst()
            let values = headlessData.compactMap { $0.intValue }
            assertWrapper(values.count == headlessData.count, "invalid data")

            return Column(
                label: label,
                type: type,
                name: chartData.names[label],
                color: chartData.colors[label],
                values: values
            )
        }

        self.init(title: chartData.title, columns: columns)
    }
}

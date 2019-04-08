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
    static func chart(id: String, at url: URL) throws -> Chart {
        let data = try Data(contentsOf: url)
        return try chart(id: id, data: data)
    }

    static func chart(id: String, data: Data) throws -> Chart {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let chartData = try decoder.decode(ChartData.self, from: data)
        return try Chart(id: id, data: chartData).get()
    }

    init?(id: String, data chartData: ChartData) {
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
                id: label,
                type: type,
                name: chartData.names[label],
                color: chartData.colors[label],
                values: values
            )
        }

        self.init(
            id: id,
            title: chartData.title,
            columns: columns,
            percentage: chartData.percentage ?? false,
            stacked: chartData.stacked ?? false,
            yScaled: chartData.yScaled ?? false
        )
    }
}

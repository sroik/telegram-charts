//
//  Copyright © 2019 sroik. All rights reserved.
//

import Foundation

extension Chart {
    static func chart(id: String, at url: URL, expandable: Bool) throws -> Chart {
        let data = try Data(contentsOf: url)
        return try chart(id: id, data: data, expandable: expandable)
    }

    static func chart(id: String, data: Data, expandable: Bool) throws -> Chart {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let chartData = try decoder.decode(ChartData.self, from: data)
        return try Chart(id: id, data: chartData, expandable: expandable).get()
    }

    init?(id: String, data chartData: ChartData, expandable: Bool) {
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
            yScaled: chartData.yScaled ?? false,
            expandable: expandable
        )
    }
}

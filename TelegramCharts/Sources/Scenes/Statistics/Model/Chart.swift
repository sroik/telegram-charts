//
//  Copyright © 2019 sroik. All rights reserved.
//

import Foundation

enum ColumnType: String, Codable {
    case timestamps = "x"
    case line
    case area
    case bar
}

struct Column: Hashable {
    let id: String
    let type: ColumnType
    let name: String?
    let color: HexColor?
    let values: [Int]
}

struct Chart: Hashable {
    let id: String
    let title: String?
    let columns: [Column]
    let percentage: Bool
    let stacked: Bool
    let yScaled: Bool
    let expandable: Bool
}

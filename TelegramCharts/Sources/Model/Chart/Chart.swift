//
//  Copyright © 2019 sroik. All rights reserved.
//

import Foundation

enum ColumnType: String, Codable {
    case timestamps = "x"
    case line
}

struct Column: Hashable {
    let label: String
    let type: ColumnType
    let name: String?
    let color: HexColor?
    let values: [Int]
}

struct Chart: Hashable {
    var columns: [Column]
}

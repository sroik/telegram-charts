//
//  Copyright © 2019 sroik. All rights reserved.
//

import Foundation

enum ColumnType: String {
    case timestamps = "x"
    case line
}

struct Column {
    let type: ColumnType
    let label: String
    let name: String
    let color: HexColor
    var values: [Int]
}

struct Chart {
    var columns: [Column]
}

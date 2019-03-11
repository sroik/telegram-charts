//
//  Copyright © 2019 sroik. All rights reserved.
//

import Foundation

struct ChartData: Decodable {
    let columns: [[AnyDecodable]]
    let colors: [String: HexColor]
    let names: [String: String]
    let types: [String: ColumnType]
}

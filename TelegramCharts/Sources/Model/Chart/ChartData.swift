//
//  Copyright © 2019 sroik. All rights reserved.
//

import Foundation

struct ChartData: Decodable {
    let title: String?
    let columns: [[AnyDecodable]]
    let colors: [String: HexColor]
    let names: [String: String]
    let types: [String: ColumnType]
    let percentage: Bool?
    let stacked: Bool?
    let yScaled: Bool?
}

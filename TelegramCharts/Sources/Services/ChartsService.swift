//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

enum ChartsError: Error {
    case invalidFile
}

protocol ChartsService {
    /*
     I know that it's should be asynchronous
     or loaded from network. But I don't have a lot of time
     for that and it's not the purpose of this contest
     */
    func load() throws -> [Chart]
}

final class BuiltinChartsService: ChartsService {
    init(file: String, in bundle: Bundle = .main) {
        fileURL = bundle.url(forResource: file, withExtension: nil)
    }

    init(fileURL: URL?) {
        self.fileURL = fileURL
    }

    func load() throws -> [Chart] {
        let url = try fileURL.or(throw: ChartsError.invalidFile)
        let charts = try Chart.charts(at: url)
        return charts
    }

    private let fileURL: URL?
}

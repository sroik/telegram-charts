//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

enum ChartsError: Error {
    case invalidPath
}

protocol ChartsService {
    /*
     I know that it should be asynchronous
     or loaded from network. But I don't have a lot of time
     for that and it's not the purpose of this contest
     */
    func charts() -> [Chart]
}

final class BuiltinChartsService: ChartsService {
    init(
        directory: String,
        basename: String = "overview",
        bundle: Bundle = .main,
        fileManager: FileManager = .default
    ) {
        self.fileManager = fileManager
        self.basename = basename
        self.bundle = bundle
        self.directory = directory
    }

    func charts() -> [Chart] {
        let subdirs = subdirectories(in: directory)
        let charts = subdirs.compactMap { subdir in
            return chart(
                id: subdir,
                in: "\(directory)/\(subdir)",
                basename: basename
            )
        }

        return charts
    }

    private func chart(id: String, in directory: String, basename: String) -> Chart? {
        guard let url = bundle.url(
            forResource: basename,
            withExtension: "json",
            subdirectory: directory
        ) else {
            assertionFailureWrapper("invalid args")
            return nil
        }

        do {
            return try Chart.chart(id: directory.basename, at: url)
        } catch {
            assertionFailureWrapper("failed to parse chart", error.localizedDescription)
            return nil
        }
    }

    private func subdirectories(in directory: String) -> [String] {
        guard let url = bundle.url(forResource: directory, withExtension: nil) else {
            assertionFailureWrapper("invalid directory")
            return []
        }

        do {
            let contents = try fileManager.contentsOfDirectory(
                at: url,
                includingPropertiesForKeys: nil,
                options: [.skipsHiddenFiles, .skipsSubdirectoryDescendants]
            )

            return contents
                .map { $0.path.basename }
                .filter { $0.ext.isEmpty }
                .sorted()
        } catch {
            assertionFailureWrapper("failed to get dir contents", error.localizedDescription)
            return []
        }
    }

    private let basename: String
    private let directory: String
    private let bundle: Bundle
    private let fileManager: FileManager
}

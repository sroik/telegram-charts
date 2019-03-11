//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

public class Environment {
    static var isPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }

    static var isPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }

    static var isTests: Bool {
        return ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
    }
}

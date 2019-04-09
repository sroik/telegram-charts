//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

protocol ChartViewportable: Viewportable {
    func enable(columns: [Column], animated: Bool)
}

typealias ChartBrowser = ChartViewportable
typealias ChartBrowserView = UIView & ChartBrowser
typealias ChartViewportableView = View & ChartViewportable

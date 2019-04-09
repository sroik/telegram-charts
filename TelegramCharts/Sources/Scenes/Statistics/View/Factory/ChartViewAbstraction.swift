//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

protocol ChartViewportable: Viewportable {
    func enable(columns: [Column], animated: Bool)
}

protocol ChartBrowserDelegate: AnyObject {
    func chartBrowser(_ view: ChartBrowserView, wantsToExpand index: Int)
}

protocol ChartBrowser: ChartViewportable {
    var delegate: ChartBrowserDelegate? { get set }
}

typealias ChartViewportableView = View & ChartViewportable
typealias ChartBrowserView = UIView & ChartBrowser

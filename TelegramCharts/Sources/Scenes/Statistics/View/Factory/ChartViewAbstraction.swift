//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

protocol ChartViewportable: Viewportable {
    func enable(columns: [String], animated: Bool)
}

protocol ChartBrowserDelegate: AnyObject {
    func chartBrowser(_ view: ChartBrowserView, wantsToExpand index: Int)
}

protocol ChartBrowser: ChartViewportable {
    var delegate: ChartBrowserDelegate? { get set }
    func deselect(animated: Bool)
}

protocol ChartViewType: ChartViewportable {
    var selectedIndex: Int? { get set }
    var contentSize: CGSize { get }
    var chart: Chart { get }
}

typealias ChartViewportableView = View & ChartViewportable
typealias ChartBrowserView = UIView & ChartBrowser
typealias ChartView = ChartViewportableView & ChartViewType

extension ChartViewType {
    var offset: CGFloat {
        return -contentSize.width * viewport.min
    }
}

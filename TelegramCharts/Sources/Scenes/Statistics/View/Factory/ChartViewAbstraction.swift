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
    func deselect(animated: Bool)
}

protocol ExpandableChartBrowser: ChartBrowser {
    var delegate: ChartBrowserDelegate? { get set }
}

protocol ChartViewType: ChartViewportable {
    var selectedIndex: Int? { get set }
    var chart: Chart { get }
}

protocol TimelineChartViewType: ChartViewType {
    var contentSize: CGSize { get }
}

typealias ChartViewportableView = View & ChartViewportable
typealias ChartBrowserView = UIView & ChartBrowser
typealias ExpandableChartBrowserView = UIView & ExpandableChartBrowser
typealias ChartView = ChartViewportableView & ChartViewType
typealias TimelineChartView = ChartViewportableView & TimelineChartViewType

extension TimelineChartViewType {
    var offset: CGFloat {
        return -contentSize.width * viewport.min
    }
}

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

protocol ChartViewType: ChartViewportable {
    var selectedIndex: Int? { get set }
    var contentSize: CGSize { get }
}

typealias ChartViewportableView = View & ChartViewportable
typealias ChartBrowserView = UIView & ChartBrowser
typealias ChartView = UIView & ChartViewType

extension ChartViewType {
    var offset: CGFloat {
        return -contentSize.width * viewport.min
    }
}

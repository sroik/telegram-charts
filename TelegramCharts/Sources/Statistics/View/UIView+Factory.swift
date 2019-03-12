//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

extension UITableView {
    static func statistics(footer: UIView = UIView()) -> UITableView {
        footer.frame = CGRect(origin: .zero, size: footer.intrinsicContentSize)
        let tableView = UITableView()
        tableView.tableFooterView = footer
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        tableView.register(
            StatisticsTableViewCell.self,
            forCellReuseIdentifier: StatisticsTableViewCell.reusableIdentifier
        )
        return tableView
    }
}

extension UIScrollView {
    static func charts() -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }
}

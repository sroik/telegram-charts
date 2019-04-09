//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

final class TimePeriodView: View {
    override func layoutSubviewsOnBoundsChange() {
        super.layoutSubviewsOnBoundsChange()
        backgroundColor = UIColor.yellow.withAlphaComponent(0.25)
    }
}

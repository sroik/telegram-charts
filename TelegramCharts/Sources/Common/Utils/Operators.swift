//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

precedencegroup Exponentiation {
    associativity: left
    higherThan: MultiplicationPrecedence
}

infix operator **: Exponentiation

func ** (lhs: CGFloat, rhs: CGFloat) -> CGFloat {
    return pow(lhs, rhs)
}

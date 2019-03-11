//
//  Copyright © 2019 sroik. All rights reserved.
//

import XCTest
import UIKit
@testable import TelegramCharts

class UIColorHexTests: XCTestCase {
    
    func testInitWithInvalidHex() {
        XCTAssertNil(UIColor(hex: "#wrong_format"))
        XCTAssertNil(UIColor(hex: "#FFFFFFFFF"))
        XCTAssertNil(UIColor(hex: "#0000"))
    }
    
    func testInitWithHex6() throws {
        XCTAssertTrue(try UIColor(hex: "#FFFFFF").get().isEqual(to: .white))
    }
    
    func testInitWithHex8() throws {
        let color = UIColor(red: 0, green: 0, blue: 0, alpha: 26/255)
        XCTAssertTrue(try UIColor(hex: "#0000001A").get().isEqual(to: color))
    }
}

//
//  CurrencyAPITests.swift
//  CurrencyCalculatorTests
//
//  Created by 임재현 on 6/4/25.
//

import XCTest
@testable import CurrencyCalculator

final class CurrencyAPITests: XCTestCase {

    func testForTDDIHateTDD() {
        let currency = ExchangeRateResponse(code: 200, message: "환율 조회 성공!", data: "1,450")
        
        XCTAssertNotNil(currency)
    }
    
}

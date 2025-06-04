//
//  CurrencyCalculatorTests.swift
//  CurrencyCalculatorTests
//
//  Created by 임재현 on 6/4/25.
//

import XCTest
@testable import CurrencyCalculator

final class CurrencyCalculatorTests: XCTestCase {
    
    func testForTDDIHateYou() {
        //Given
        let calculator = CurrencyCalculator()
        
        //Then
        XCTAssertNotNil(calculator, "환율계산기 앱")
//     XCTAssertNil(calculator, "환율계산기 앱")
    }
}

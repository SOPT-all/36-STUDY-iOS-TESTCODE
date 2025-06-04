//
//  CurrencyCalculatorTests.swift
//  CurrencyCalculatorTests
//
//  Created by 임재현 on 6/4/25.
//

import XCTest
@testable import CurrencyCalculator

final class CurrencyCalculatorTests: XCTestCase {
    
    func testConvertKRWToUSD() {
        //Given
        let calculator = CurrencyCalculator()
        
        //When
        let from = CurrencyType.KRW
        let to = CurrencyType.USD
        let amount = 1300.0
        let rate = 1300.0
        
        let result = calculator.convertToUSD(amount: amount,
                                             from: from,
                                             to: to,
                                             rate: rate)
        
        //Then
        XCTAssertEqual(result, 1, "1300원 환율 기준 1300원은 1달러 입니다.")
    }
    
    func testConvertUSDToKRW() {
        //Given
        let calculator = CurrencyCalculator()
        
        //When
        let from = CurrencyType.USD
        let to = CurrencyType.KRW
        let amount = 3.0
        let rate = 1300.0
        
        let result = calculator.convertToUSD(amount: amount,
                                             from: from,
                                             to: to,
                                             rate: rate)
        
        //Then
        XCTAssertEqual(result, 3900, "3달러는 3900원.")
    }
    
    func testConvertSameCurrency() {
        //Given
        let calculator = CurrencyCalculator()
        
        //When
        let from = CurrencyType.KRW
        let to = CurrencyType.KRW
        let amount = 300000.0
        let rate = 1300.0
        
        let result = calculator.convertToUSD(amount: amount,
                                             from: from,
                                             to: to,
                                             rate: rate)
        
        //Then
        XCTAssertEqual(result, amount, "같은 통화 기준")
    }
}

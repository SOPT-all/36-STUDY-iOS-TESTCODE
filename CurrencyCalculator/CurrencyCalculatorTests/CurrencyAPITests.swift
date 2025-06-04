//
//  CurrencyAPITests.swift
//  CurrencyCalculatorTests
//
//  Created by 임재현 on 6/4/25.
//

import XCTest
@testable import CurrencyCalculator

final class CurrencyAPITests: XCTestCase {

    var mockService: MockExchangeRateService!
    
    override func setUp() {
        super.setUp()
        mockService = MockExchangeRateService()
    }
    
    override func tearDown() {
        mockService = nil
        super.tearDown()
    }
    
    func testForResponseData() {
        let currency = ExchangeRateResponse(code: 200, message: "환율 조회 성공!", data: "1,450")
        
        XCTAssertNotNil(currency)
    }
    
    
    func testFetchExchangeRateSuccess() {
        // Given
        let expectedResponse = ExchangeRateResponse(
            code: 200,
            message: "환율 조회 성공!",
            data: "1,450"
        )
        mockService.mockResponse = .success(expectedResponse)
        
        let expectation = XCTestExpectation(description: "API 호출 성공")
        
        // When
        mockService.fetchExchangeRate(from: "안알랴줌") { result in
            // Then
            switch result {
            case .success(let response):
                XCTAssertEqual(response.code, 200)
                XCTAssertEqual(response.message, "환율 조회 성공!")
                XCTAssertEqual(response.data, "1,450")
            case .failure:
                XCTFail("성공해야 하는 테스트에서 실패")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFetchExchangeRateNetworkError() {
        // Given
        mockService.mockResponse = .failure(NetworkError.networkError(NSError(domain: "TestError", code: -1, userInfo: nil)))
        
        let expectation = XCTestExpectation(description: "네트워크 에러")
        
        // When
        mockService.fetchExchangeRate(from: "안알랴줌") { result in
            // Then
            switch result {
            case .success:
                XCTFail("에러가 발생해야 함")
            case .failure(let error):
                XCTAssertTrue(error is NetworkError)
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
}

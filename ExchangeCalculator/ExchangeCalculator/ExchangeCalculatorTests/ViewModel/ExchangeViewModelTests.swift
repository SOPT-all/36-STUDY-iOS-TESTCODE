import XCTest
@testable import ExchangeCalculator

final class ExchangeViewModelTests: XCTestCase {

    func testCalculateKRWPerUSD() {
        let exchangeModel = ExchangeModel(data: "1,450")
        let exchangeViewModel = ExchangeViewModel(exchangeModel: exchangeModel)
        
        let krw = exchangeViewModel.calculateKRW(forUSD: 1)
        
        XCTAssertEqual(krw, 1_450)
    }
    
    func testConvertWhenUSDIsNotNumericString() {
        let exchangeModel = ExchangeModel(data: "exchange")
        let exchangeViewModel = ExchangeViewModel(exchangeModel: exchangeModel)
        
        let krw = exchangeViewModel.calculateKRW(forUSD: 1)
        
        XCTAssertEqual(krw, 0)
    }
}

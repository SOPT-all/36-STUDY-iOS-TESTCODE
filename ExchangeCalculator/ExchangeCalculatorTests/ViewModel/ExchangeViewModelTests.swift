import XCTest
@testable import ExchangeCalculator

final class ExchangeViewModelTests: XCTestCase {
    
    func testFetchExchange() async throws {
        let _ = XCTestExpectation(description: "환율_가져오기_성공")
        
        let exchangeViewModel = ExchangeViewModel()
        
        let receivedData = try await exchangeViewModel.fetchExchange()
                
        XCTAssertEqual(receivedData, "1,450")
    }
}

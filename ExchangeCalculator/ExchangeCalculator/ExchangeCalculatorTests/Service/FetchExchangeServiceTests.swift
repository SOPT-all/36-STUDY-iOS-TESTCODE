import XCTest
@testable import ExchangeCalculator

final class FetchExchangeServiceTests: XCTestCase {
    
    private let service = FetchExchangeService()
    
    func testFetchExchange() async throws {
        let expectation = XCTestExpectation(description: "환율_가져오기_성공")
        
        let receivedData = try await service.fetchExchange()
                
        XCTAssertEqual(receivedData, "1,450")
    }
}

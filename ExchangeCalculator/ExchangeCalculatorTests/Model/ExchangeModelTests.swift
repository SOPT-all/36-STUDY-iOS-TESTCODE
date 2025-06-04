import XCTest
@testable import ExchangeCalculator

final class ExchangeModelTests: XCTestCase {

    func testCreateExchangeModel() {
        let exchangeModel = ExchangeModel(data: "1,450")
        XCTAssertNotNil(exchangeModel)
    }
}

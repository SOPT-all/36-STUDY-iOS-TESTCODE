import UIKit

class FetchExchangeService {
    
    private let baseURLString = "https://98107e2c-a68e-4e89-bacf-85f13c9a1652.mock.pstmn.io/money"
    
    func fetchExchange() async throws -> String {
        guard let url = makeURL() else {
            return "0"
        }
        let request = makeRequest(url: url)
        let (data, _) = try await dataTask(request: request)
        
        return try decode(data: data)
    }
    
    private func makeURL() -> URL? {
        return URL(string: baseURLString)
    }
    
    private func makeRequest(url: URL) -> URLRequest {
        return URLRequest(url: url)
    }
    
    private func dataTask(request: URLRequest) async throws -> (Data, URLResponse) {
        return try await URLSession.shared.data(for: request)
    }
    
    private func decode(data: Data) throws -> String {
        do {
            let decoded = try JSONDecoder().decode(ExchangeModel.self, from: data)
            let exchange = decoded.data
            return exchange
        } catch {
            throw NSError(domain: "ExchangeError", code: -1, userInfo: nil)
        }
    }
}

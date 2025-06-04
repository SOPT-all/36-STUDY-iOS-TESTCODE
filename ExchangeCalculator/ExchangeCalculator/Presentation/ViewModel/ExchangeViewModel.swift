import UIKit

final class ExchangeViewModel {
    
    private let baseURLString = "https://98107e2c-a68e-4e89-bacf-85f13c9a1652.mock.pstmn.io/money"
    
    var onKRWCalculated: ((String) -> Void)?
    var onError: ((String) -> Void)?
    
    func fetchAndCalculateKRW(forUSD: Int) {
        Task {
            do {
                let fetchedExchange = try await fetchExchange()
                let krwRate = convert(data: fetchedExchange)
                let result = krwRate * forUSD
                onKRWCalculated?("\(result) 원")
            } catch {
                onError?("환율 정보를 불러오지 못했습니다.")
            }
        }
    }
    
    func fetchExchange() async throws -> String {
        guard let url = URL(string: baseURLString) else {
            return "0"
        }
        let request = URLRequest(url: url)
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let decoded = try JSONDecoder().decode(ExchangeModel.self, from: data)
        return decoded.data
    }
    
    private func convert(data: String) -> Int {
        let newDataString = data.replacingOccurrences(of: ",", with: "")
        guard let converted = Int(newDataString) else {
            return 0
        }
        return converted
    }
}

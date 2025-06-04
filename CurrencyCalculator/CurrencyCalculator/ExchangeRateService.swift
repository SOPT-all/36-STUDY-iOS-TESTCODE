//
//  ExchangeRateService.swift
//  CurrencyCalculator
//
//  Created by 임재현 on 6/4/25.
//

import Foundation

protocol ExchangeRateServiceProtocol {
    func fetchExchangeRate(from baseURL: String, completion: @escaping (Result<ExchangeRateResponse, Error>) -> Void)
}

class ExchangeRateService: ExchangeRateServiceProtocol {
    private let urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func fetchExchangeRate(from baseURL: String, completion: @escaping (Result<ExchangeRateResponse, Error>) -> Void) {
        guard let url = URL(string: baseURL) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        urlSession.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(NetworkError.networkError(error)))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let exchangeRateResponse = try JSONDecoder().decode(ExchangeRateResponse.self, from: data)
                completion(.success(exchangeRateResponse))
            } catch {
                completion(.failure(NetworkError.decodingError))
            }
        }.resume()
    }
}

class MockExchangeRateService: ExchangeRateServiceProtocol {
    var mockResponse: Result<ExchangeRateResponse, Error>?
    var shouldDelay: Bool = false
    var delayTime: TimeInterval = 0.1
    
    func fetchExchangeRate(from baseURL: String, completion: @escaping (Result<ExchangeRateResponse, Error>) -> Void) {
        let executeCompletion = {
            if let mockResponse = self.mockResponse {
                completion(mockResponse)
            } else {
                // 기본 성공 응답
                let defaultResponse = ExchangeRateResponse(
                    code: 200,
                    message: "환율 조회 성공!",
                    data: "1,450"
                )
                completion(.success(defaultResponse))
            }
        }
        
        if shouldDelay {
            DispatchQueue.main.asyncAfter(deadline: .now() + delayTime) {
                executeCompletion()
            }
        } else {
            executeCompletion()
        }
    }
}

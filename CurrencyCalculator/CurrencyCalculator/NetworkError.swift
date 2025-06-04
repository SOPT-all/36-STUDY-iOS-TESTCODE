//
//  NetworkError.swift
//  CurrencyCalculator
//
//  Created by 임재현 on 6/4/25.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
    case networkError(Error)
}

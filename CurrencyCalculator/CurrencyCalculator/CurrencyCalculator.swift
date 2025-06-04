//
//  CurrencyCalculator.swift
//  CurrencyCalculator
//
//  Created by 임재현 on 6/4/25.
//

import Foundation

enum CurrencyType: String {
    case KRW
    case USD
}

final class CurrencyCalculator {
    static let shared = CurrencyCalculator()
    func convertToUSD(amount: Double,
                      from: CurrencyType,
                      to: CurrencyType,
                      rate: Double) -> Double {
        
        if from == .USD && to == .KRW {
            return amount * rate
        } else if from == .KRW && to == .USD {
            return amount / rate
        }
        return amount
    }
    
    func fetchCurrency() {
        
    }
    
    
    
}

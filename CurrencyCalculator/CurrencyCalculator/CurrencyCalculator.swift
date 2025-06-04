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
    func convertToUSD(amount: Int,
                      from: CurrencyType,
                      to: CurrencyType,
                      rate: Int) -> Int {
        
        if from == .USD && to == .KRW {
            return amount * rate
        } else if from == .KRW && to == .USD {
            return amount / rate
        }
        return amount
    }
}

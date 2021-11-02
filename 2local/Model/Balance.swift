//
//  Balance.swift
//  2Local
//
//  Created by Hasan Sedaghat on 9/4/19.
//  Copyright © 2019 Hasan Sedaghat. All rights reserved.
//

import UIKit

class Balance: Codable {
    var currency: String?
    var balance: Double?
    var code: String?

    
    enum CodingKeys : String , CodingKey {
        case currency = "currency"
        case balance = "balance"
        case code = "code"
    }

    static func monetaryValue(amount: String?) -> Double {
        if (amount != nil) && amount != "" {
            if Double(amount!) != nil {
                let money = Double(Double(DataProvider.shared.exchangeRate?.defaultExR ?? "0")! * Double(amount ?? "0")!)
                return money
            }
            return 0.0
        }
        else {
            return 0.0
        }
    }
    
    static func monetaryValue(of ico: Coins, amount: String?) -> Double {
        if (amount != nil) && amount != "" {
            if Double(amount!) != nil {
                switch ico {
                case .TLocal:
                    return Double(Double(DataProvider.shared.exchangeRate?.defaultExR ?? "0")! * Double(amount ?? "0")!)
                case .Ethereum:
                    return Double(truncating: (DataProvider.shared.exchangeRate?.ethereum?.defaultExchangeRate ?? 0) as NSDecimalNumber) * Double(amount ?? "0")!
                case .Bitcoin:
                    return Double(truncating: (DataProvider.shared.exchangeRate?.bitcoin?.defaultExchangeRate ?? 0) as NSDecimalNumber) * Double(amount ?? "0")!
                case .Stellar:
                    return Double(truncating: (DataProvider.shared.exchangeRate?.stellar?.defaultExchangeRate ?? 0) as NSDecimalNumber) * Double(amount ?? "0")!
                case .Binance:
                    return 0
                }
            }
            return 0.0
        }
        else {
            return 0.0
        }
    }
}

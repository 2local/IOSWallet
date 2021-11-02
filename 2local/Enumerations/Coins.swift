//
//  Coins.swift
//  2local
//
//  Created by Ebrahim Hosseini on 4/3/21.
//  Copyright © 2021 2local Inc. All rights reserved.
//

import Foundation

enum Coins: String, CaseIterable {
    case Bitcoin, Ethereum, Stellar, Binance
    case TLocal = "2local"
    
    
    func symbol() -> String {
        switch self {
        case .Bitcoin:
            return "BTC"
        case .Ethereum:
            return "ETH"
        case .Stellar:
            return "XLM"
        case .TLocal:
            return "2LC"
        case .Binance:
            return "BNB"
        }
    }
    
    func icon() -> String {
        switch self {
        case .Bitcoin:
            return ""
        case .Ethereum:
            return "ethereum"
        case .Stellar:
            return ""
        case .TLocal:
            return "logo"
        case .Binance:
            return "binance"
        }
    }
    
    func name() -> String {
        switch self {
        case .Bitcoin:
            return userDefaults.string(forKey: Coins.Bitcoin.rawValue) ?? "Bitcoin"
        case .Ethereum:
            return userDefaults.string(forKey: Coins.Bitcoin.rawValue) ?? "Ethereum"
        case .Stellar:
            return userDefaults.string(forKey: Coins.Bitcoin.rawValue) ?? "Stellar"
        case .TLocal:
            return userDefaults.string(forKey: Coins.Bitcoin.rawValue) ?? "2local"
        case .Binance:
            return userDefaults.string(forKey: Coins.Bitcoin.rawValue) ?? "Binance"
        }
    }
}



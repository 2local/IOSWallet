//
//  Coins.swift
//  2local
//
//  Created by Ebrahim Hosseini on 4/3/21.
//  Copyright © 2021 2local Inc. All rights reserved.
//

import Foundation

enum Coins: String, Codable, CaseIterable {
    case bitcoin, ethereum, stellar, binance
    case tLocal = "2local"

    func symbol() -> String {
        switch self {
        case .bitcoin:
            return "BTC"
        case .ethereum:
            return "ETH"
        case .stellar:
            return "XLM"
        case .tLocal:
            return "2LC"
        case .binance:
            return "BNB"
        }
    }

    func icon() -> String {
        switch self {
        case .bitcoin:
            return ""
        case .ethereum:
            return "ethereum"
        case .stellar:
            return ""
        case .tLocal:
            return "logo"
        case .binance:
            return "binance"
        }
    }

    func name() -> String {
        switch self {
        case .bitcoin:
            return userDefaults.string(forKey: Coins.bitcoin.rawValue) ?? "Bitcoin"
        case .ethereum:
            return userDefaults.string(forKey: Coins.bitcoin.rawValue) ?? "Ethereum"
        case .stellar:
            return userDefaults.string(forKey: Coins.bitcoin.rawValue) ?? "Stellar"
        case .tLocal:
            return userDefaults.string(forKey: Coins.bitcoin.rawValue) ?? "2local"
        case .binance:
            return userDefaults.string(forKey: Coins.bitcoin.rawValue) ?? "Binance"
        }
    }
}

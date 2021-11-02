//
//  WalletFactory.swift
//  2local
//
//  Created by Ebrahim Hosseini on 5/5/21.
//  Copyright © 2021 2local Inc. All rights reserved.
//

import Foundation

struct WalletFactory {
    static func getWallets(wallet: Wallets) -> WalletProtocol {
        switch wallet.name {
        case .TLocal:
            return TLocalWallet(wallet: wallet)
        case .Ethereum:
            return EthereumWallet(wallet: wallet)
        case .Bitcoin:
             return BitcoinWallet(wallet: wallet)
        case .Stellar:
            return StellarWallet(wallet: wallet)
        case .Binance:
            return BinanceWallet(wallet: wallet)
        }
    }
}

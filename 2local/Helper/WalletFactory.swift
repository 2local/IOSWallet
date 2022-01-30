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
      case .tLocal:
        return TLocalWallet(wallet: wallet)
      case .ethereum:
        return EthereumWallet(wallet: wallet)
      case .bitcoin:
        return BitcoinWallet(wallet: wallet)
      case .stellar:
        return StellarWallet(wallet: wallet)
      case .binance:
        return BinanceWallet(wallet: wallet)
    }
  }
}

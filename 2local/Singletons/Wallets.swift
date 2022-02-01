//
//  Wallets.swift
//  2local
//
//  Created by Ebrahim Hosseini on 5/5/21.
//  Copyright © 2021 2local Inc. All rights reserved.
//

import Foundation

struct Wallets: Codable {
  var name: Coins
  var displayName = ""
  var balance = "0"
  var address = ""
  var mnemonic = ""

  init(name: Coins, balance: String, address: String, mnemonic: String, displayName: String) {
    self.name = name
    self.balance = balance
    self.address = address
    self.mnemonic = mnemonic
    self.displayName = displayName
  }
}

extension Wallets {
  var currency: String {
    return DataProvider.shared.defaultEx ?? "USD"
  }

  var currencySymbol: String {
    return DataProvider.shared.exchangeRate?.defaultSym ?? "$"
  }
}

extension Wallets {
  func balance(_ index: Int) -> String {
    guard DataProvider.shared.wallets.count > 0 else { return "0" }
    if name == .ethereum {
      var balance = "0"
      Web3Service.getETHBalance { (etherBalance) in
        balance = etherBalance ?? "0"
      }
      return balance
    }
    return (DataProvider.shared.wallets[index].balance ?? "0").convertToPriceType()
  }

  func fiat(_ index: Int) -> String {
    guard DataProvider.shared.wallets.count > 0 else { return "0" }
    if name == .ethereum {
      var fiat = "0"
      Web3Service.getETHFiatBalance { (fiatBalance) in
        fiat = fiatBalance
      }
      return fiat
    }
    let fiat = Double(Balance.monetaryValue(amount: DataProvider.shared.wallets[index].balance ?? "0"))
    return String(fiat).convertToPriceType()
  }
}

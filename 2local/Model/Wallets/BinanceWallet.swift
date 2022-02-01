//
//  BinanceWallet.swift
//  2local
//
//  Created by Ebrahim Hosseini on 7/17/21.
//  Copyright © 2021 2local Inc. All rights reserved.
//

import Foundation
import BigInt
import web3swift

struct BinanceWallet: WalletProtocol {

  var wallet: Wallets
  var gasLimit: BigUInt = 21000
  private var action = "txlist"

  init(wallet: Wallets) {
    self.wallet = wallet
  }

  func balance() -> String {
    return wallet.balance
  }

  var symbol: String {
    return wallet.name.symbol()
  }

  var name: String {
    wallet.displayName
  }

  var icon: String {
    return wallet.name.icon()
  }

  var address: String {
    return wallet.address
  }

  func fiat(from balance: Double?, completionHandler: @escaping (String) -> Void) {
    let balance: Double = balance ?? Double(self.balance())!
    var fiat = 0.0
    fee { (value) in
      fiat = Double(value ?? "0")! * balance
      completionHandler(String(fiat).convertToPriceType())
    }
  }

  func fee(_ completionHandler: @escaping (String?) -> Void) {
    Web3Service.shared.getFee(of: wallet.name) { (value) in
      completionHandler(value)
    }
  }

  func gasPrice(_ complertionHandler: @escaping (String, String, String) -> Void) {
    Web3Service.shared.getBSCGasPrice { (gasPrice) in
      guard let gasPrice = gasPrice else { return }
      complertionHandler(String(describing: gasPrice), String(describing: gasPrice), String(describing: gasPrice))
    }
  }

  func send(_ to: String, amount: BigUInt, gasPrice: BigUInt, completionHandler: @escaping (String) -> Void) {
    Web3Service.shared.sendBNB(walletAddress: wallet.address,
                               receiverAddress: to,
                               bnbAmount: "\(amount)",
                               gasPrice: gasPrice,
                               gasLimit: gasLimit) { (txHash) in
      completionHandler(txHash)
    }
  }

  func getTransactionHistory(by address: String, completionHandler: @escaping ([TransactionHistoryModel]?) -> Void) {
    Web3Service.shared.getBSCTransactionHistory(by: address, contractAddress: "", action: action) { (transactions) in
      completionHandler(transactions)
    }
  }
}

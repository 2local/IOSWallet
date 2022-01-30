//
//  TLocalWallet.swift
//  2local
//
//  Created by Ebrahim Hosseini on 5/5/21.
//  Copyright © 2021 2local Inc. All rights reserved.
//

import Foundation
import BigInt

struct TLocalWallet: WalletProtocol {

  var wallet: Wallets
  var gasLimit: BigUInt = 61_000
  private var contractAddress: String = "&contractaddress=0x11f6ecc9e2658627e0876212f1078b9f84d3196e"

  init(wallet: Wallets) {
    self.wallet = wallet
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

  func balance() -> String {
    return wallet.balance
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

  func gasPrice(_ completionHandler: @escaping (String, String, String) -> Void) {
    Web3Service.shared.getBSCGasPrice { (gasPrice) in
      guard let gasPrice = gasPrice else { return }
      completionHandler(String(describing: gasPrice), String(describing: gasPrice), String(describing: gasPrice))
    }
  }

  func send(_ toAddress: String,
            amount: BigUInt,
            gasPrice: BigUInt,
            completionHandler: @escaping (String) -> Void) {
    Web3Service.shared.sendBEP20Token(walletAddress: wallet.address,
                                      receiverAddress: toAddress,
                                      tokenAmount: "\(amount)",
                                      gasPrice: gasPrice,
                                      gasLimit: gasLimit) { txHash in
      completionHandler(txHash)
    }
  }

  func getTransactionHistory(by address: String, completionHandler: @escaping ([TransactionHistoryModel]?) -> Void) {
    Web3Service.shared.getBSCTransactionHistory(by: address, contractAddress: contractAddress) { (transactions) in
      completionHandler(transactions)
    }
  }
}

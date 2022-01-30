//
//  EthereumWallet.swift
//  2local
//
//  Created by Ebrahim Hosseini on 5/5/21.
//  Copyright © 2021 2local Inc. All rights reserved.
//

import Foundation
import BigInt
import Web3
import Web3ContractABI
import Web3PromiseKit

struct EthereumWallet: WalletProtocol {

  var wallet: Wallets

  init(wallet: Wallets) {
    self.wallet = wallet
  }

  var gasLimit: BigUInt = 21000

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
    return Web3Service.currentAddress ?? ""
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

  func getTransactionHistory(by address: String, completionHandler: @escaping ([TransactionHistoryModel]?) -> Void) {
    Web3Service.shared.getETHTransactionHistory(by: wallet.address) { (transactions) in
      completionHandler(transactions)
    }
  }

  func gasPrice(_ complertionHandler: @escaping (String, String, String) -> Void) {
    Web3Service.shared.getETHGasPrice { (gasPriceModel) in
      if let gas = gasPriceModel {
        let low = gas.safeGasPrice
        let normal = gas.proposeGasPrice
        let high = gas.fastGasPrice
        complertionHandler(low, normal, high)
      } else {
        complertionHandler("0", "0", "0")
      }
    }
  }
  func send(_ toAddress: String,
            amount: BigUInt,
            gasPrice: BigUInt,
            completionHandler: @escaping (String) -> Void) {
    /// get infura network url
    let url = Configuration.shared.infuraUrl
    let web3 = Web3(rpcURL: url)
    /// get private key
    guard let privateKeyHex = Web3Service.getPrivateKey() else { return }
    guard let privateKey = try? EthereumPrivateKey(hexPrivateKey: privateKeyHex) else { return }
    firstly {
      web3.eth.getTransactionCount(address: privateKey.address, block: .latest)
    }.then { nonce in
      try EthereumTransaction(
        nonce: nonce,
        gasPrice: EthereumQuantity(quantity: gasPrice.gwei),
        gas: EthereumQuantity(quantity: gasLimit),
        to: EthereumAddress(hex: toAddress, eip55: false),
        value: EthereumQuantity(quantity: amount))
        .sign(with: privateKey, chainId: 1)
        .promise
    }.then { transaction in
      web3.eth.sendRawTransaction(transaction: transaction)
    }.done { hash in
      let txHash = hash.hex()
      completionHandler(txHash)
    }.catch { error in
      completionHandler("error: \(error.localizedDescription)")
    }
  }
}

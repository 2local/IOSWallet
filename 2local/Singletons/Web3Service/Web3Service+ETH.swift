//
//  Web3Service+ETH.swift
//  2local
//
//  Created by Ebrahim Hosseini on 7/23/21.
//  Copyright © 2021 2local Inc. All rights reserved.
//

import Foundation
import Web3
import web3swift

// MARK: - ETH implementation
extension Web3Service {
  /// ETH receive address
  static var currentAddress: String? {
    guard let mnemonics = userDefaults.string(forKey: UserDefaultsKey.ETHWallet.rawValue) else { return nil}
    let wallet = Wallet(type: .BIP39(mnemonic: mnemonics))
    guard let address = wallet.address else { return nil}
    return address
  }

  /// Get ETH balance
  /// - Parameter completion: ETH balance
  static func getETHBalance(completion: @escaping (String?) -> Void) {
    let infura = Web3.InfuraMainnetWeb3(accessToken: Configuration.shared.infuraToken)

    guard let address = Web3Service.currentAddress else { return }
    let walletAddress = EthereumAddress(address)!

    guard let balanceResult = try? infura.eth.getBalance(address: walletAddress) else { return }
    let balanceString = Web3.Utils.formatToEthereumUnits(balanceResult, toUnits: .eth, decimals: 5)!
    completion(balanceString.convertToPriceType())
  }

  /// Get ETH Fiat
  /// - Parameter completion: ETH Fiat balance
  static func getETHFiatBalance(completion: @escaping (String) -> Void) {
    Web3Service.getETHBalance { (balance) in
      let fiat = Balance.monetaryValue(of: .ethereum, amount: balance ?? "0")
      let stringFiat = String(fiat).convertToPriceType()
      completion(stringFiat)
    }
  }

  /// Get ETH private key
  /// - Returns: private key
  static func getPrivateKey() -> String? {
    guard let mnemonics = userDefaults.string(forKey: UserDefaultsKey.ETHWallet.rawValue) else { return nil }
    let wallet = Wallet(type: .BIP39(mnemonic: mnemonics))
    let data = wallet.data!
    let keystoreManager: KeystoreManager
    if wallet.isHD {
      let keystore = BIP32Keystore(data)!
      keystoreManager = KeystoreManager([keystore])
    } else {
      let keystore = EthereumKeystoreV3(data)!
      keystoreManager = KeystoreManager([keystore])
    }

    let ethereumAddress = EthereumAddress(wallet.address!)!
    let pkData = try? keystoreManager.UNSAFE_getPrivateKeyData(password: wallet.password,
                                                               account: ethereumAddress).toHexString()
    return pkData
  }

  /// Get local gas price
  /// - Returns: gas price
  static func getLocalGasPrice() -> Int {
    let infura: web3 = Web3.InfuraMainnetWeb3()
    do {
      let gas = try infura.eth.getGasPrice()
      let gasGwei = Web3Utils.formatToEthereumUnits(gas,
                                                    toUnits: .Gwei,
                                                    decimals: 3,
                                                    decimalSeparator: ".")
      return Int(gasGwei ?? "0") ?? 0
    } catch {
      return 0
    }
  }

  func getETHGasPrice(_ completionHandler: @escaping (GasPriceModel?) -> Void) {
    APIManager.shared.getGasPrice { (data, response, _) in
      let result = APIManager.processResponseETHScan(response: response, data: data)
      if result.status {
        do {
          let gasPrice = try JSONDecoder().decode(ResultData<GasPriceModel>.self, from: data!).result
          if let data = gasPrice {
            completionHandler(data)
          }
        } catch {
          completionHandler(nil)
        }
      }
    }
  }
  /// Ether transactions history
  /// - Parameters:
  ///   - address: user wallet address
  ///   - completionHandler: array of ETH transactions
  func getETHTransactionHistory(by address: String,
                                completionHandler: @escaping ([TransactionHistoryModel]?) -> Void) {
    APIManager.shared.getETHTransactionStatus(receiveAddress: address) { (data, response, _) in
      let result = APIManager.processResponseETHScan(response: response, data: data)
      if result.status {
        do {
          let transaction = try JSONDecoder().decode(ResultData<[TransactionHistoryModel]>.self,
                                                     from: data!).result
          guard let data = transaction, data.count > 0 else {
            completionHandler(nil)
            return
          }
          completionHandler(data.reversed())
        } catch {
          completionHandler(nil)
        }
      } else {
        completionHandler(nil)
      }
    }
  }
}

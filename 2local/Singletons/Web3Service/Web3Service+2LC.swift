//
//  Web3Service+2LC.swift
//  2local
//
//  Created by Ebrahim Hosseini on 7/23/21.
//  Copyright © 2021 2local Inc. All rights reserved.
//

import Foundation
import Web3
import Web3PromiseKit
import web3swift
import KVNProgress

// MARK: - 2local implementation
extension Web3Service {

  /// Creat 2lc wallet by importing private key
  /// - Parameters:
  ///   - privateKey: 2LC private key
  /// - Throws: return an error
  /// - Returns: A wallet address
  func import2LCBy(privateKey: String, completion: @escaping (String?) -> Void) throws {
    do {
      guard let privateKeyData = Data.fromHex(privateKey) else {
        KVNProgress.showError(withStatus: "Private key is not valid!")
        return
      }
      let keyStore = try EthereumKeystoreV3(privateKey: privateKeyData,
                                      password: password,
                                      aesMode: aesMode)
      let jsonEncoder = JSONEncoder()
      let keydata = try jsonEncoder.encode(keyStore?.keystoreParams)

      let walletAddress = keyStore?.addresses?.first

      let keystore = String(data: keydata, encoding: String.Encoding.utf8)

      Web3Service.shared.writeToFile(fileName: walletAddress!.address, keystore: keydata)

      completion(walletAddress?.address)
    } catch {
      print(error.localizedDescription)
      throw error
    }
  }

  /// Get BEP20 token balance
  /// - Parameters:
  ///   - walletAddress: wallet address
  ///   - completion:
  /// - Returns: balance
  func getBEP20TokenBalance(walletAddress: String) throws -> String? {

    do {
      let contractAddress = EthereumAddress(tokenContractAddress)
      let contract = self.web3Manager.contract(Web3Utils.erc20ABI, at: contractAddress, abiVersion: 2)!
      guard let decimals = try contract.method("decimals")?.call() else { return "0" }
      guard let balance = try contract.method("balanceOf",
                                              parameters: [walletAddress] as [AnyObject],
                                              extraData: Data(),
                                              transactionOptions: TransactionOptions.defaultOptions)?.call() else { return "0" }

      guard let numStr = decimals["0"] else { return "0" }
      let decimal = Double("\(numStr)")

      guard let balanceStr = balance["balance"] ?? balance["0"] else { return "0" }

      guard let tokenBalance = Double("\(balanceStr)") else { return "0" }
      let tokenBal = tokenBalance/pow(10, decimal!)

      return String(tokenBal)

    } catch {
      print(error.localizedDescription)
      throw error
    }
  }

  /// Send BEP20 token
  /// - Parameters:
  ///   - walletAddress: sender wallet address
  ///   - receiverAddress: receiver wallet address
  ///   - tokenAmount: amount
  ///   - gasPrice: pas price
  ///   - gasLimit: gas limit
  /// - Throws:
  /// - Returns: a txHash string
  func sendBEP20Token(walletAddress: String,
                      receiverAddress: String,
                      tokenAmount: String,
                      gasPrice: BigUInt,
                      gasLimit: BigUInt,
                      completionHandler: @escaping (String) -> Void) {
    do {

      if  Web3Service.shared.findKeystoreMangerByAddress(walletAddress: walletAddress) == nil {
        completionHandler("Keystore does not exist")
      }

      let contractAddress =  EthereumAddress(tokenContractAddress)
      let receviverBnbAddress =  EthereumAddress(receiverAddress)
      let senderBnbAddress = EthereumAddress(walletAddress)
      let contract = Web3Service.shared.web3Manager.contract(Web3Utils.erc20ABI, at: contractAddress, abiVersion: 2)!

      let token = ERC20(web3: Web3Service.shared.web3Manager,
                        provider: Web3Service.shared.isMainnet() ? Web3.InfuraMainnetWeb3().provider : Web3.InfuraRopstenWeb3().provider,
                        address: EthereumAddress(tokenContractAddress)!)
      token.readProperties()

      let amount = Web3.Utils.parseToBigUInt(tokenAmount, decimals: Int(token.decimals))

      var options = TransactionOptions.defaultOptions

      options.from = senderBnbAddress
      let gweiUnit = BigUInt(1000000000)
      options.gasPrice = .manual(gasPrice * gweiUnit)
      options.gasLimit = .manual(gasLimit)

      let contratInstance = try contract.method("transfer",
                                                parameters: [receviverBnbAddress as Any, amount as Any] as [AnyObject],
                                                extraData: Data(),
                                                transactionOptions: options)?.send(password: "", transactionOptions: options)

      guard let transaction = contratInstance?.hash else {
        completionHandler("Error to get the txHash")
        return
      }

      completionHandler(transaction)

    } catch {
      print(error.localizedDescription)
      completionHandler(error.localizedDescription)
    }

  }

  /// Get Token gas price
  /// - Parameter completion:
  /// - Returns: a BigUInt
  func getBSCGasPrice(_ completion: @escaping (BigUInt?) -> Void) {
    APIManager.shared.getBSCGasPrice { (data, _, _) in
      do {
        let gasPrice = try JSONDecoder().decode(BSCResult<String>.self, from: data!).result
        if let gasPrice = gasPrice {
          if let value = BigUInt(gasPrice.stripHexPrefix, radix: 16) {
            completion(value/1000000000)
          }
        }
      } catch {
        print("Error to fetch gas")
        completion(nil)
      }
    }
  }
}

//
//  Web3Service+BNB.swift
//  2local
//
//  Created by Ebrahim Hosseini on 7/23/21.
//  Copyright © 2021 2local Inc. All rights reserved.
//

import Foundation
import web3swift
import BigInt

// MARK: - BNB implementation
extension Web3Service {

    /// Get BNB balance
    /// - Parameter walletAddress: wallet address
    /// - Throws:
    /// - Returns: BNB balance
    func getBNBBalance(walletAddress: String) throws -> String {
        do {
            guard let bnbAddress = EthereumAddress(walletAddress) else { return "0" }
            let balancebigint = try Web3Service.shared.web3Manager.eth.getBalance(address: bnbAddress)
            let bnbBalance  = (String(describing: Web3.Utils.formatToEthereumUnits(balancebigint)!))
            return bnbBalance
        } catch {
            print(error.localizedDescription)
            throw error
        }
    }

    /// send BNB smart chain
    /// - Parameters:
    ///   - walletAddress: sender wallet address
    ///   - receiverAddress: receiver wallet address
    ///   - bnbAmount: amount
    ///   - gasPrice: pas price
    ///   - gasLimit: gas limit (21000)
    /// - Throws:
    /// - Returns: a txHash string
    func sendBNB(walletAddress: String, receiverAddress: String, bnbAmount: String,
                 gasPrice: BigUInt, gasLimit: BigUInt, completionHandler: @escaping (String) -> Void) {

        do {
            let keystoreManager =  Web3Service.shared.findKeystoreMangerByAddress(walletAddress: walletAddress)
            if keystoreManager == nil {
                completionHandler("Keystore does not exist")
            }

            let bnbSenderAddress = EthereumAddress(walletAddress)!
            let resBnbAddress = EthereumAddress(receiverAddress)!
            let contract = Web3Service.shared.web3Manager.contract(Web3.Utils.coldWalletABI, at: resBnbAddress, abiVersion: 2)!
            let amount = Web3.Utils.parseToBigUInt(bnbAmount, units: .eth)
            var options = TransactionOptions.defaultOptions
            options.value = amount
            options.from = bnbSenderAddress
            let gweiUnit = BigUInt(1000000000)
            options.gasPrice = .manual(gasPrice * gweiUnit)
            options.gasLimit = .manual(gasLimit)

            let tx = contract.write(
                "fallback",
                parameters: [AnyObject](),
                extraData: Data(),
                transactionOptions: options)!

            let result = try tx.send(password: password)
            completionHandler(result.hash)
        } catch {
            print(error.localizedDescription)
            completionHandler(error.localizedDescription)
        }

    }

}

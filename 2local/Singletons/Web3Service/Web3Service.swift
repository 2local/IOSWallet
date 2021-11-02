//
//  Web3SwiftService.swift
//  2local
//
//  Created by Ebrahim Hosseini on 5/12/21.
//  Copyright © 2021 2local Inc. All rights reserved.
//

import Foundation
import web3swift
import BigInt
import SwiftyJSON
import Alamofire

class Web3Service {
    static let shared = Web3Service()
    
    var infuraUrl: String!
    var tokenContractAddress = Configuration.shared.tokenContractAddress
    var password = Configuration.shared.password
    var aesMode = Configuration.shared.aesMode
    var web3Manager: web3!
    
    init() {
        let userDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let keystoreManager = KeystoreManager.managerForPath(userDir + "/keystore")
        self.infuraUrl = "https://bsc-dataseed.binance.org"
        guard let url = URL(string: self.infuraUrl) else { return }
        guard let provider = Web3HttpProvider(url) else { return }
        self.web3Manager = web3(provider: provider)
        self.web3Manager.addKeystoreManager(keystoreManager)
    }
    
    func isMainnet() -> Bool {
        return self.infuraUrl.contains("https://bsc-dataseed1.binance.org:443")
    }
    
    func writeToFile(fileName : String , keystore : Data){
        let userDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        FileManager.default.createFile(atPath: userDir + "/keystore/" + fileName.lowercased() +  ".json", contents: keystore, attributes: nil)
    }
    
    func findKeystoreMangerByAddress(walletAddress : String) -> EthereumKeystoreV3? {
        let bnbWalletAddress = EthereumAddress(walletAddress)
        let userDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let keystoreManager = KeystoreManager.managerForPath(userDir + "/keystore")
        for i in keystoreManager?.keystores ?? [] {
            if (i.getAddress()?.address.lowercased() == bnbWalletAddress?.address.lowercased()){
                return i
            }
        }
        return nil
    }
    
}

//MARK: - get token fee
extension Web3Service {
    
    /// Get fee from symbols
    /// - Parameters:
    ///   - coin: Coins (2LC, BNB, ...)
    ///   - completionHandler: return a price in string type
    func getFee(of coin: Coins, completionHandler: @escaping (String?) -> ()) {
        APIManager.shared.getFee(of: coin.symbol()) { (data, response, error) in
            guard let data = data else {
                completionHandler("0")
                return
            }
            do {
                let price = try JSONDecoder().decode(BITRUEResult<String>.self, from: data).price
                if let price = price {
                    completionHandler(price)
                }
            } catch {
                print("Error to fetch gas")
                completionHandler(nil)
            }
        }
    }
    
    func getBSCTransactionHistory(by address: String, contractAddress: String, action: String = "tokentx", completionHandler: @escaping ([TransactionHistoryModel]?) -> Void) {
        APIManager.shared.getBSCTransaction(address: address, contractAddress: contractAddress, action: action) { (data, response, error) in
            do {
                guard let data = data else {
                    completionHandler(nil)
                    return
                }
                let transaction = try JSONDecoder().decode(BSCArrayResult<TransactionHistoryModel>.self, from: data).result
                completionHandler(transaction)
            } catch {
                completionHandler(nil)
            }
        }
    }
}

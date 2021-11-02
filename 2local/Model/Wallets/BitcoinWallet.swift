//
//  BitcoinWallet.swift
//  2local
//
//  Created by Ebrahim Hosseini on 5/5/21.
//  Copyright © 2021 2local Inc. All rights reserved.
//

import Foundation
import BigInt

struct BitcoinWallet: WalletProtocol {
    var gasLimit: BigUInt = 0
    
    func gasPrice(_ complertionHandler: @escaping (String, String, String) -> Void) {
        complertionHandler("0", "0", "0")
    }
    
    func send(_ to: String, amount: BigUInt, gasPrice: BigUInt, completionHandler: @escaping (String) -> Void) {
        
    }
    
    
    var wallet: Wallets
    
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
        wallet.name.icon()
    }
    
    var address: String {
        return wallet.address
    }

    func balance() -> String {
        return "0"
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
        completionHandler(nil)
    }
    
    
}

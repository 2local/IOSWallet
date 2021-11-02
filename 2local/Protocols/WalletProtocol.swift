//
//  WalletProtocol.swift
//  2local
//
//  Created by Ebrahim Hosseini on 5/5/21.
//  Copyright © 2021 2local Inc. All rights reserved.
//

import Foundation
import BigInt

protocol WalletProtocol {
    var wallet: Wallets { get }
    var gasLimit: BigUInt { get }
    var icon: String { get }
    var name: String { get }
    var address: String { get }
    var symbol: String { get }
    
    func gasPrice(_ complertionHandler: @escaping (String, String, String) -> Void)
    func balance() -> String
    func fiat(from balance: Double?, completionHandler: @escaping (String) -> Void)
    func fee(_ completionHandler: @escaping (String?) -> Void)
    func getTransactionHistory(by address: String, completionHandler: @escaping ([TransactionHistoryModel]?) -> Void)
    func send(_ to: String, amount: BigUInt, gasPrice: BigUInt, completionHandler: @escaping (String) -> Void)
}

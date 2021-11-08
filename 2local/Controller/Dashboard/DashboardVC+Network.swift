//
//  DashboardVC+Network.swift
//  2local
//
//  Created by Ibrahim Hosseini on 10/10/21.
//  Copyright © 2021 2local Inc. All rights reserved.
//

import Foundation
import KVNProgress

extension DashboardVC {
    //MARK: - Common
    
    /// get all transactions
    func getTransactions(_ wallets: [Wallets], completion: @escaping (([Transfer]) -> Void)) {
        var transfers = [Transfer]()
        guard wallets.count > 0 else { return }
        
        wallets.forEach { wallet in
            let currentWallet = WalletFactory.getWallets(wallet: wallet)
            currentWallet.getTransactionHistory(by: currentWallet.address) { [ weak self] (transactions) in
                guard self != nil else { return }
                guard let transactions = transactions else { return }
                Transfer.mapTransactions(transactions, wallet: currentWallet.address) { [weak self] transfer in
                    guard self != nil else { return }
                    transfers.append(contentsOf: transfer)
                }
            }
        }
        completion(transfers)
    }
    
    /// get total fiats
    func getTotalFiat(_ wallets: [Wallets], completion: @escaping ((Double) -> Void)) {
        var totalFiat: Double = 0
        guard wallets.count > 0 else { return }
        wallets.forEach { (wallet) in
            let currentWallet = WalletFactory.getWallets(wallet: wallet)
            let balance = Double(currentWallet.balance())
            currentWallet.fiat(from: balance) { (fiat) in
                totalFiat += Double(fiat)!
                completion(totalFiat)
            }
        }
    }
    
    //MARK: - 2LC
    func get2localPublickey() -> String {
        guard let publicKey = DataProvider.shared.user?.wallet else { return "" }
        return publicKey
    }
    
    //MARK: - ETH
    
    /// get ETH balance
    func getETHBalance() -> String? {
        guard let wallet = DataProvider.shared.wallets.filter({$0.name == Coins.Ethereum}).first else { return nil }
        return wallet._balance
    }
    
    func getFiatOfETH(of balance: String) -> String {
        guard let wallet = DataProvider.shared.wallets.filter({$0.name == Coins.Ethereum}).first else { return "0" }
        return wallet.fiat(1)
    }
}

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
    // MARK: - Common

    /// get all transactions
    func getTransactions(_ wallets: [Wallets], completion: @escaping (([Transfer]) -> Void)) {
        var transfers = [Transfer]()
        guard wallets.count > 0 else { return }

        wallets.forEach { wallet in
            let currentWallet = WalletFactory.getWallets(wallet: wallet)
            currentWallet.getTransactionHistory(by: currentWallet.address) { [ weak self] (transactions) in
                guard let self = self else { return }
                guard let transactions = transactions else { return }
                Transfer.mapTransactions(transactions, wallet: currentWallet.wallet) { [weak self] transfer in
                    guard let _ = self else { return }
                    transfer.forEach { (result) in
                        if result.amount ?? "0" != "0" {
                            transfers.append(result)
                        }
                    }
                    completion(transfers)
                }
            }
        }
    }

    /// get total fiats
    func getTotalFiat(_ wallets: [Wallets], completion: @escaping ((Double) -> Void)) {
        var totalFiat: Double = 0
        guard wallets.count > 0 else { return }
        wallets.forEach { (wallet) in
            if wallet.name != Coins.tLocal { return }
            let currentWallet = WalletFactory.getWallets(wallet: wallet)
            let balance = Double(currentWallet.balance())
            currentWallet.fiat(from: balance) { (fiat) in
                totalFiat += Double(fiat)!
                completion(totalFiat)
            }
        }
    }

    func get2localBalance(_ wallets: [Wallets], completion: @escaping ((Double) -> Void)) {
        guard let tlcWallet = wallets.filter({$0.name == .tLocal}).first else {
            completion(0)
            return
        }
        let wallet = WalletFactory.getWallets(wallet: tlcWallet)
        let balance = (Double(wallet.balance()) ?? 0)
        completion(balance)
    }

    // MARK: - 2LC
    func get2localPublickey() -> String {
        guard let publicKey = DataProvider.shared.user?.wallet else { return "" }
        return publicKey
    }

    // MARK: - ETH

    /// get ETH balance
    func getETHBalance() -> String? {
        guard let wallet = DataProvider.shared.wallets.filter({$0.name == Coins.ethereum}).first else { return nil }
        return wallet.balance
    }

    func getFiatOfETH(of balance: String) -> String {
        guard let wallet = DataProvider.shared.wallets.filter({$0.name == Coins.ethereum}).first else { return "0" }
        return wallet.fiat(1)
    }
}

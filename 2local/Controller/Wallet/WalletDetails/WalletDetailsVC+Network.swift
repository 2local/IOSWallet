//
//  WalletDetailsVC+Network.swift
//  2local
//
//  Created by Ebrahim Hosseini on 4/22/21.
//  Copyright © 2021 2local Inc. All rights reserved.
//

import Foundation
import KVNProgress

extension WalletDetailsVC {
    func getTransactionHistory() {
        DispatchQueue.main.async {
            KVNProgress.show(withStatus: "", on: self.view)
        }
        currentWallet.getTransactionHistory(by: currentWallet.address) { [ weak self] (transactions) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                KVNProgress.dismiss()
            }
            guard let transactions = transactions, transactions.count > 0 else {
                DispatchQueue.main.async {
                    self.emptyBoxStack.isHidden = false
                }
                return
            }

            transactions.forEach { (result) in
                if result.value ?? "0" != "0" {
                    self.allTransactions.append(result)
                }
            }

            self.transactionHistory = self.allTransactions
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

//
//  TransactionConfirmVC+Network.swift
//  2local
//
//  Created by Ebrahim Hosseini on 6/3/21.
//  Copyright © 2021 2local Inc. All rights reserved.
//

import Foundation
import Web3
import Web3PromiseKit
import Web3ContractABI
import KVNProgress

extension TransactionConfirmVC {
    func getGasPrice(_ completionHandler: @escaping (GasPriceModel) -> Void) {
        KVNProgress.show()
        currentWallet.gasPrice { (low, normal, high) in
            let gasModel = GasPriceModel(safeGasPrice: low, proposeGasPrice: normal, fastGasPrice: high, lastBlock: "")
            completionHandler(gasModel)
        }
    }
}

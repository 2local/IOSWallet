//
//  DataProvider.swift
//  2local
//
//  Created by Hasan Sedaghat on 12/28/19.
//  Copyright © 2019 2local Inc. All rights reserved.
//

import Foundation
import KeychainSwift

class DataProvider: NSObject {
    static let shared = DataProvider()

    var wallets: [Wallets] = []
    let keychain = KeychainSwift()
    var user: User?
    var exchangeRate: ExchangeRate?
    var defaultEx: String?
    var orders = [Order]()
    var transfers = [Transfer]()
    var transactions = [Transfer]()
    let issuer = Configuration.shared.issuer
    let issuingKeys = Configuration.shared.issuingKeys
    let sourceKey = Configuration.shared.sourceKey
    let publicKey = Configuration.shared.publicKey
    let stellarWalletNumber = Configuration.shared.stellarWalletNumber
    let etheriumWalletNumber = Configuration.shared.etheriumWalletNumber
    let bitcoinWalletNumber = Configuration.shared.bitcoinWalletNumber

    var places = [Companies]()
}

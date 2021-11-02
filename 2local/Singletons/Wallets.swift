//
//  Wallets.swift
//  2local
//
//  Created by Ebrahim Hosseini on 5/5/21.
//  Copyright © 2021 2local Inc. All rights reserved.
//

import Foundation

struct Wallets {
    var _name: Coins
    var _displayName: String?
    var _balance: String?
    var _address: String?
    var _mnemonic: String?

    init(name: Coins, balance: String?, address: String?, mnemonic: String?, displayName: String) {
        self._name = name
        self._balance = balance
        self._address = address
        self._mnemonic = mnemonic
        self._displayName = displayName
    }
}

extension Wallets {
    var name: Coins {
        self._name
    }
    
    var displayName: String {
        return userDefaults.string(forKey: name.rawValue) ?? self.name.rawValue
    }
    
    var currency: String {
        return DataProvider.shared.defaultEx ?? "USD"
    }
    
    var currencySymbol: String {
        return DataProvider.shared.exchangeRate?.defaultSym ?? "$"
    }
    
    var mnemonic: String {
        guard let mnemonic = _mnemonic else { return ""}
        return mnemonic
    }
    
    var address: String {
        guard let address = _address else { return "" }
        return address
    }
    
    var balance: String {
        guard let balance = _balance else { return "" }
        return balance
    }
}

extension Wallets {
    func balance(_ index: Int) -> String {
        guard DataProvider.shared.wallets.count > 0 else { return "0" }
        if _name == .Ethereum {
            var balance = "0"
            Web3Service.getETHBalance { (etherBalance) in
                balance = etherBalance ?? "0"
            }
            return balance
        }
        return (DataProvider.shared.wallets[index]._balance ?? "0").convertToPriceType()
    }
    
    func fiat(_ index: Int) -> String {
        guard DataProvider.shared.wallets.count > 0 else { return "0" }
        if _name == .Ethereum {
            var fiat = "0"
            Web3Service.getETHFiatBalance { (fiatBalance) in
                fiat = fiatBalance
            }
            return fiat
        }
        let fiat = Double(Balance.monetaryValue(amount: DataProvider.shared.wallets[index]._balance ?? "0"))
        return String(fiat).convertToPriceType()
    }
}

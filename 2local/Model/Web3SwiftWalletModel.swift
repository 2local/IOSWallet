//
//  Web3SwiftWalletModel.swift
//  2local
//
//  Created by Ebrahim Hosseini on 4/12/21.
//  Copyright © 2021 2local Inc. All rights reserved.
//

import Foundation
import web3swift

struct Wallet: Codable {
  enum WalletType {
    case ethereumKeyStoreV3
    case BIP39(mnemonic: String)
  }

  var name: String = "Wallet"
  var bitsOfEntropy: Int = 128 // Entropy is a measure of password strength. Usually used 128 or 256 bits.
  var password = "web3swift" // We recommend here and everywhere to use the password set by the user.

  var address: String?

  var data: Data?
  var mnemonics: String? {
    didSet {
      guard let keyStore = try? BIP32Keystore(
        mnemonics: self.mnemonics!,
        password: password,
        mnemonicsPassword: "",
        language: .english) else { return }
      if let data = try? JSONEncoder().encode(keyStore.keystoreParams) {
        self.data = data
      }
      self.isHD = true
      self.address = keyStore.addresses!.first!.address
    }
  }
  var isHD: Bool = true

  init(type: WalletType) {
    switch type {
      case .ethereumKeyStoreV3:
        guard let keystore = try? EthereumKeystoreV3(password: password) else { return }
        self.address = keystore.addresses!.first!.address
        if let data = try? JSONEncoder().encode(keystore.keystoreParams) {
          self.data = data
        }
        self.isHD = false
        self.address = keystore.addresses!.first!.address
      case .BIP39(mnemonic: let mnemonic):
        do {
          guard let keystore = try BIP32Keystore(
            mnemonics: mnemonic,
            password: password,
            mnemonicsPassword: "",
            language: .english) else { return }
          self.name = "HD Wallet"
          if let data = try? JSONEncoder().encode(keystore.keystoreParams) {
            self.data = data
          }
          self.isHD = true
          self.address = keystore.addresses!.first!.address
        } catch {
          print("error to create a wallet")
        }
    }
  }
}

struct HDKey {
  let name: String?
  let address: String
}

struct ERC20Token {
  var name: String
  var address: String
  var decimals: String
  var symbol: String
}

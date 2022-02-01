//
//  EditWalletVC.swift
//  2local
//
//  Created by Ebrahim Hosseini on 5/13/21.
//  Copyright © 2021 2local Inc. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class EditWalletVC: BaseVC {

  // MARK: - Outlets
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var descLabel: UILabel!
  @IBOutlet weak var walletNameTextField: SkyFloatingLabelTextField!
  @IBOutlet weak var cancelButton: UIButton!
  @IBOutlet weak var actionButton: UIButton!
  @IBOutlet weak var closeButton: UIButton!
  @IBOutlet weak var containerView: UIView!

  // MARK: - Properties
  var renameCallBack: ((Coins) -> Void)?
  var removeCallBack: ((Coins) -> Void)?
  var cancelCallBack: SimpleAction = nil
  var closeCallBack: SimpleAction = nil

  private var action: WalletAction?
  private var wallet: Wallets?

  func initWith(_ action: WalletAction, wallet: Wallets) {
    self.action = action
    self.wallet = wallet
    DispatchQueue.main.async {
      if action == .rename {
        self.titleLabel.text = "Wallet name".localized
        self.walletNameTextField.isHidden = false
        self.descLabel.isHidden = true
        self.actionButton.setTitle("Confirm", for: .normal)
        self.actionButton.backgroundColor = .EF8749
        self.walletNameTextField.text = wallet.displayName
      }
      if action == .remove {
        self.titleLabel.text = "Remove \(wallet.displayName) wallet".localized
        self.walletNameTextField.isHidden = true
        self.descLabel.isHidden = false
        self.actionButton.setTitle("Remove wallet", for: .normal)
        self.actionButton.backgroundColor = .FE6C6C
      }
    }
  }

  // MARK: - View cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }

  // MARK: - Functions
  fileprivate func setupView() {
    actionButton.setCornerRadius(8)

    cancelButton.setCornerRadius(8)
    cancelButton.setBorderWith(.e0e0eb, width: 1)

    tapToDismiss()

    containerView.setShadow(color: .color707070,
                            opacity: 0.5,
                            offset: CGSize(width: 0, height: 0),
                            radius: 10)
  }

  // MARK: - Actions
  @IBAction func closeTapped(_ sender: UIButton) {
    dismiss(animated: true)
  }

  @IBAction func actionTapped(_ sender: UIButton) {
    switch action {
      case .rename:
        guard let name = self.wallet?.name else { return }
        if var wallet = DataProvider.shared.wallets.filter({$0.name == name}).first {
          wallet.displayName = self.walletNameTextField.text ?? ""
          userDefaults.setValue(self.walletNameTextField.text, forKey: name.rawValue)
          NotificationCenter.default.post(name: Notification.Name.walletRename, object: nil)
          dismiss(animated: true)
        }
      case .remove:
        guard let name = self.wallet?.name else { return }

        if let wallet = DataProvider.shared.wallets.filter({$0.name == name}).first {

          switch wallet.name {
            case .binance:
              userDefaults.removeObject(forKey: UserDefaultsKey.BNBWallet.rawValue)
            case .ethereum:
              userDefaults.removeObject(forKey: UserDefaultsKey.ETHWallet.rawValue)
            case .tLocal:
              userDefaults.removeObject(forKey: UserDefaultsKey.TLCWallet.rawValue)
            case .stellar:
              userDefaults.removeObject(forKey: UserDefaultsKey.XLMWallet.rawValue)
            case .bitcoin:
              userDefaults.removeObject(forKey: UserDefaultsKey.BTCWallet.rawValue)
          }

          let wallets = DataProvider.shared.wallets

          for index in 0..<wallets.count {
            if wallets[index].name == wallet.name {
              DataProvider.shared.wallets.remove(at: index)
            }
          }

          NotificationCenter.default.post(name: Notification.Name.walletRemove, object: nil)
          dismiss(animated: true)
        }
      default:
        break
    }
  }
}

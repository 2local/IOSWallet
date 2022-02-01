//
//  ReceiveViewController.swift
//  2local
//
//  Created by Hasan Sedaghat on 1/1/20.
//  Copyright © 2020 2local Inc. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import KVNProgress

class ReceiveViewController: BaseVC {

  @IBOutlet var scrollView: UIScrollView!
  @IBOutlet var qrCodeIMG: UIImageView!
  @IBOutlet weak var walletSymbolLabel: UILabel! {
    didSet {
      walletSymbolLabel.text = currentWallet.symbol
    }
  }
  @IBOutlet var walletNumberTXF: SkyFloatingLabelTextField! {
    didSet {
      walletNumberTXF.titleFont = .TLFont(weight: .medium,
                                          size: 12)
      walletNumberTXF.placeholderFont = .TLFont()
      walletNumberTXF.font = .TLFont(weight: .regular,
                                     size: 14)
    }
  }
  @IBOutlet var amountTXF: SkyFloatingLabelTextField! {
    didSet {
      amountTXF.titleFont = .TLFont(weight: .medium,
                                    size: 12)
      amountTXF.placeholderFont = .TLFont()
      amountTXF.font = .TLFont(weight: .regular,
                               size: 14)
    }
  }
  @IBOutlet var balanceLabel: UILabel!
  @IBOutlet var currencyLabel: UILabel!
  @IBOutlet var costLabel: UILabel!
  @IBOutlet weak var requestButton: UIButton!

  // MARK: - properties
  private var wallet: Wallets?
  private var currentWallet: WalletProtocol!
  var fee: Double = 0

  func initWith(_ wallet: Wallets) {
    currentWallet = WalletFactory.getWallets(wallet: wallet)
  }

  // MARK: - view cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    currentWallet.fee { (fee) in
      guard let fee = fee else { return }
      self.fee = Double(fee)!
    }

    getWalletData()
  }

  // MARK: - functions
  fileprivate func setupView() {
    KVNProgress.show()
    qrCodeIMG.setCornerRadius(5)
    self.scrollView.handleKeyboard()
    self.view.tapToDismissKeyboard()
    self.amountTXF.addTarget(self, action: #selector(amountCalculation), for: .editingChanged)

    setNavigation(title: "Receive")
  }

  fileprivate func getWalletData() {
    let address = currentWallet.address
    walletNumberTXF.text = address
    qrCodeIMG.image = generateQRCode(from: address)
    balanceLabel.text = "Available: \(currentWallet.balance()) \(currentWallet.symbol)"
    currencyLabel.text = DataProvider.shared.defaultEx ?? "USD"

    KVNProgress.dismiss()
  }

  @objc func amountCalculation() {
    guard let amount = self.amountTXF.text, let doubleAmount = Double(amount) else {
      self.costLabel.text = ""
      return
    }
    let cost = doubleAmount * fee
    UIView.transition(with: self.costLabel,
                      duration: 0.3,
                      options: .transitionFlipFromTop) { [self] in
      self.costLabel.text = String(cost).convertToPriceType()
    }
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "goToReceipt" {
      if let destVC = segue.destination as? ReceiveReceiptViewController {
        guard let number = walletNumberTXF.text,
              let amount = amountTXF.text,
              let cost = costLabel.text,
              let wallet = wallet else { return }
        destVC.initWith(number,
                        amount: amount,
                        cost: cost,
                        walletTypeName: wallet.name)
      }
    }
  }

  // MARK: - actions
  @IBAction func request(_ sender: Any) {
    if amountTXF.text != "" {
      self.performSegue(withIdentifier: "goToReceipt", sender: nil)
    } else {
      KVNProgress.showError(withStatus: "Amount field is empty\nPlease fill it")
    }
  }

  @IBAction func copyAddress(_ sender: Any) {
    UIPasteboard.general.string = self.walletNumberTXF.text
    KVNProgress.showSuccess(withStatus: "Wallet number copied to clipboard")
  }

}

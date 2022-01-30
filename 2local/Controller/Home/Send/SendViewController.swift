//
//  SendViewController.swift
//  2local
//
//  Created by Hasan Sedaghat on 1/1/20.
//  Copyright © 2020 2local Inc. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import KVNProgress
import Web3
import web3swift

class SendViewController: BaseVC, ScanWalletNumberDelegate, UIGestureRecognizerDelegate {

  // MARK: - outlets
  @IBOutlet var walletNumberTXF: SkyFloatingLabelTextField! {
    didSet {
      walletNumberTXF.titleFont = .TLFont(weight: .medium,
                                          size: 12)
      walletNumberTXF.placeholderFont = .TLFont()
      walletNumberTXF.font = .TLFont(weight: .regular,
                                     size: 14)
      walletNumberTXF.text = walletNumber
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
  @IBOutlet var costLabel: UILabel!
  @IBOutlet var currencyLabel: UILabel! {
    didSet {
      currencyLabel.text = DataProvider.shared.defaultEx ?? "USD"
    }
  }
  @IBOutlet var balanceLabel: UILabel! {
    didSet {
      walletQueue.async { [self] in
        DispatchQueue.main.async {
          balanceLabel.text = "Available: \(currentWallet.balance()) \(currentWallet.symbol)"
        }
      }
    }
  }

  @IBOutlet weak var walletSymbolLabel: UILabel! {
    didSet {
      walletSymbolLabel.text = currentWallet.symbol
    }
  }
  @IBOutlet var moreBTN: UIButton!
  @IBOutlet var scanBTN: UIButton!
  @IBOutlet weak var sendButton: UIButton!

  @IBOutlet var addressbookHeight: NSLayoutConstraint!
  @IBOutlet var addressBookTableView: UITableView! {
    didSet {
      addressBookTableView.delegate = self
      addressBookTableView.dataSource = self
      addressBookTableView.layer.cornerRadius = 8
      addressBookTableView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner, .layerMinXMinYCorner]
    }
  }
  @IBOutlet var moreTableContainerView: UIView! {
    didSet {
      moreTableContainerView.setShadow(color: UIColor.color000372, opacity: 1, offset: CGSize(width: 0, height: 0), radius: 10)
      moreTableContainerView.alpha = 0
    }
  }
  @IBOutlet var addressBookContainerView: UIView! {
    didSet {
      addressBookContainerView.setShadow(color: UIColor.color000372, opacity: 1, offset: CGSize(width: 0, height: 0), radius: 10)
      addressBookContainerView.alpha = 0
    }
  }
  @IBOutlet var moreTableView: UITableView! {
    didSet {
      moreTableView.delegate = self
      moreTableView.dataSource = self
      moreTableView.layer.cornerRadius = 8
      moreTableView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner, .layerMinXMinYCorner]
    }
  }

  // MARK: - Properties
  let moreTitles = ["Paste", "Address book"]
  var addressbook = [Contact]()
  var calculationActive = false
  var walletNumber = ""
  var currentWallet: WalletProtocol!

  var fee: Double = 0

  private var wallet: Wallets?

  func initWith(_ wallet: Wallets) {
    currentWallet = WalletFactory.getWallets(wallet: wallet)
    self.wallet = wallet
  }

  // MARK: - view cycle
  override func viewDidLoad() {
    super.viewDidLoad()

    self.walletNumberTXF.addTarget(self, action: #selector(handleClearBTN), for: .editingChanged)
    self.amountTXF.addTarget(self, action: #selector(amountCalculation), for: .editingChanged)
    self.amountTXF.delegate = self
    if let contactsData = UserDefaults.standard.object(forKey: "contacts") {
      let contactsItems = try? PropertyListDecoder().decode([Contact].self, from: (contactsData as? Data)!)
      self.addressbook = contactsItems!
    }
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeTable(_:)))
    tapGesture.cancelsTouchesInView = false
    self.view.addGestureRecognizer(tapGesture)

    DispatchQueue.main.async { [self] in
      self.sendButton.backgroundColor = .mediumSlateBlue
    }
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    getFee()
  }

  // MARK: - Actions
  @IBAction func more(_ sender: Any) {
    if self.scanBTN.alpha == 0 {
      self.walletNumberTXF.text = ""
      self.handleClearBTN()
    } else {
      if moreTableContainerView.alpha == 0 {
        UIView.animate(withDuration: 0.2) {
          self.moreTableContainerView.alpha = 1
        }
      }
    }
  }

  @IBAction func scan(_ sender: Any) {
    //        self.performSegue(withIdentifier: "goToScan", sender: nil)
    let vc = UIStoryboard.scan.instantiate(viewController: ScanViewController.self)
    vc.initWith(false)
    vc.scannerDelegate = self
    vc.modalPresentationStyle = .fullScreen
    present(vc, animated: true, completion: nil)
  }

  @IBAction func send(_ sender: Any) {
    if self.walletNumberTXF.text! != currentWallet.address {

      guard let wallet = wallet else { return }

      //            if wallet.name == .tLocal {
      //                self.transfer()
      //            }

      //            if wallet.name == .Ethereum {
      let vc = UIStoryboard.transaction.instantiate(viewController: TransactionConfirmVC.self)
      let navc = TLNavigationController(rootViewController: vc)
      navc.modalPresentationStyle = .overFullScreen
      if let amount = amountTXF.text, !amount.isEmpty, let to = walletNumberTXF.text, !to.isEmpty {
        vc.initWith(amount, to: to, wallet: wallet)
        present(navc, animated: true)
      }
      //            }
    } else {
      KVNProgress.showError(withStatus: "You cannot send \(currentWallet.symbol) to your wallet!")
    }
  }

  // MARK: - Functions
  fileprivate func getFee() {
    walletQueue.async {
      self.currentWallet.fee { (fee) in
        guard let fee = fee else { return }
        self.fee = Double(fee)!
      }
    }
  }

  func walletDidScan(str: String?) {
    walletNumberTXF.text = str
    handleClearBTN()
  }

  @objc func handleClearBTN() {
    if walletNumberTXF.text!.count == 0 {
      UIView.animate(withDuration: 0.2) {
        self.scanBTN.alpha = 1
        self.moreBTN.setImage(#imageLiteral(resourceName: "more"), for: .normal)
      }
    } else {
      UIView.animate(withDuration: 0.2) {
        self.scanBTN.alpha = 0
        self.moreBTN.setImage(#imageLiteral(resourceName: "textfieldClear"), for: .normal)
      }
    }
  }

  @objc func amountCalculation() {
    guard let amount = self.amountTXF.text, let doubleAmount = Double(amount) else {
      self.costLabel.text = ""
      return
    }
    let cost = doubleAmount * fee
    UIView.transition(with: self.costLabel, duration: 0.3, options: .transitionFlipFromTop, animations: { [self] in
      self.costLabel.text = String(cost).convertToPriceType()
    }) { (_) in
      // self.calculationActive = false
    }
  }

  @objc func closeTable(_ sender: Any) {
    if moreTableContainerView.alpha == 1 || self.addressBookContainerView.alpha == 1 {
      UIView.animate(withDuration: 0.2) {
        self.moreTableContainerView.alpha = 0
        self.addressBookContainerView.alpha = 0
      }
    } else {
      self.view.endEditing(true)
    }
  }

  func transfer() {
    KVNProgress.show()
    APIManager.shared.transfer(amount: (self.amountTXF.text)!, walletNumber: (self.walletNumberTXF.text)!) { (data, response, _) in
      let result = APIManager.processResponse(response: response, data: data)
      if result.status {
        self.getBalance()
        self.getTransferOrder()
        DispatchQueue.main.async {
          KVNProgress.dismiss {
            self.performSegue(withIdentifier: "goToReceipt", sender: nil)
          }
        }
      } else {
        DispatchQueue.main.async {
          KVNProgress.showError(withStatus: result.message)
        }
      }
    }
  }

  func getTransferOrder() {
    APIManager.shared.getTransferOrderDetail(userId: "\(DataProvider.shared.user!.id ?? 0)") { (data, response, _) in
      let result = APIManager.processResponse(response: response, data: data)
      if result.status {
        do {
          let transfers = try JSONDecoder().decode(ResultData<[Transfer]>.self, from: data!).record
          DataProvider.shared.transfers = (transfers?.map({ (transfer) -> Transfer in
            var localTransfer = transfer
            localTransfer.source = localTransfer.source!.lowercased()
            return localTransfer
          }))!
        } catch {
          DispatchQueue.main.async {
            KVNProgress.showError(withStatus: "Failed to parse transfers history data\nPlease contact us.")
          }
        }
      } else {
        DispatchQueue.main.async {
          KVNProgress.showError(withStatus: result.message)
        }
      }
    }
  }

  func getBalance() {
    walletQueue.async { [self] in
      DataProvider.shared.user?.balance = Double(currentWallet.balance()) ?? 0
    }
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "goToReceipt" {
      if let navVC = segue.destination as? UINavigationController {
        if let destVC = navVC.children.first as? SendReceiptViewController {
          destVC.walletNumber = self.walletNumberTXF.text!
          destVC.amount = self.amountTXF.text!
          destVC.cost = self.costLabel.text!
        }
      }
    } else if segue.identifier == "goToScan" {
      if let navVC = segue.destination as? UINavigationController {
        if let destVC = navVC.children.first as? ScanWalletViewController {
          destVC.delegate = self
        }
      }
    }
  }
}

// MARK: - UITable view controller
extension SendViewController: UITableViewDelegate, UITableViewDataSource {

  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if tableView == moreTableView {
      return 2
    }
    return addressbook.count
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if tableView == moreTableView {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? PaymentMethodTableViewCell else { return UITableViewCell() }
      cell.titleLabel.text = self.moreTitles[indexPath.row]
      cell.selectionStyle = .none
      return cell
    } else {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? AddressBookTableViewCell else { return UITableViewCell() }
      cell.nameLabel.text = self.addressbook[indexPath.row].name
      cell.walletNumberLabel.text = self.addressbook[indexPath.row].walletNumber
      cell.selectionStyle = .none
      return cell
    }
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if tableView == moreTableView {
      if indexPath.row == 0 {
        self.walletNumberTXF.text = UIPasteboard.general.string
        self.handleClearBTN()
      } else {
        addressBookTableView.reloadData()
        self.addressbookHeight.constant = CGFloat(56 * self.addressbook.count)
        if self.addressbookHeight.constant >= 168 {
          self.addressbookHeight.constant = 168
        }
        UIView.animate(withDuration: 0.2, animations: {
          self.moreTableContainerView.alpha = 0
          self.addressBookContainerView.alpha = 1

        }, completion: nil)
      }
    } else {
      self.walletNumberTXF.text = self.addressbook[indexPath.row].walletNumber
      self.handleClearBTN()
    }
  }
}

// MARK: - UITextField Delegation
extension SendViewController: UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    if string != "" && textField.text!.count > 5 {
      return false
    }
    return true
  }
}

// MARK: - Scanner data delegation
extension SendViewController: ScannerDelegate {
  func getValue(_ value: String) {
    walletNumberTXF.text = value
  }
}

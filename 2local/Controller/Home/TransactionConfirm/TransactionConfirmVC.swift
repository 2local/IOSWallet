//
//  TransactionConfirmVC.swift
//  2local
//
//  Created by Ebrahim Hosseini on 6/3/21.
//  Copyright © 2021 2local Inc. All rights reserved.
//

import UIKit
import BigInt
import web3swift
import Web3
import KVNProgress

class TransactionConfirmVC: BaseVC {

  // MARK: - Outlets
  @IBOutlet weak var amountLabel: UILabel!
  @IBOutlet weak var gasFeeLabel: UILabel!
  @IBOutlet weak var toLabel: UILabel!
  @IBOutlet weak var gasSegment: UISegmentedControl!
  @IBOutlet weak var coinValueLabel: UILabel!
  @IBOutlet weak var confirmButton: UIButton!
  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var gasStackView: UIStackView!

  // MARK: - Properties
  var wallet: Wallets?
  var amount: String = "0"
  var gasFee: Double = 0
  var fee: Double = 0
  var gasModel: GasPriceModel?
  var to: String = ""
  var value: BigUInt = 0
  var currentWallet: WalletProtocol!

  func initWith(_ amount: String, to: String, wallet: Wallets) {
    self.wallet = wallet
    self.amount = amount
    self.to = to

    currentWallet = WalletFactory.getWallets(wallet: wallet)
  }

  // MARK: - View cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    getGasPrice { [weak self] (gasModel) in
      guard let self = self else { return }
      self.gasModel = gasModel
      guard let normalGasFee = Double(gasModel.proposeGasPrice) else {
        KVNProgress.dismiss()
        return
      }
      self.gasFee = normalGasFee
      DispatchQueue.main.async {
        KVNProgress.dismiss {
          let controrl = UISegmentedControl()
          controrl.selectedSegmentIndex = 1
          self.gasTapped(controrl)
        }
      }
    }
    currentWallet.fee { (fee) in
      guard let fee = fee else { return }
      self.fee = Double(fee)!
    }
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }

  // MARK: - Functions
  fileprivate func setupView() {
    confirmButton.setCornerRadius(8)

    gasSegment.setTitleTextAttributes([.font: UIFont.TLFont(weight: .regular,
                                                            size: 13,
                                                            style: .body),
                                       .foregroundColor: UIColor.color303030],
                                      for: .normal)

    gasSegment.setTitleTextAttributes([.font: UIFont.TLFont(weight: .medium,
                                                            size: 13,
                                                            style: .body),
                                       .foregroundColor: UIColor.white],
                                      for: .selected)

    if #available(iOS 13.0, *) {
      gasSegment.selectedSegmentTintColor = .mediumSlateBlue
    } else {
      gasSegment.tintColor = .mediumSlateBlue
    }

    containerView.setCornerRadius(25)
    containerView.setShadow(color: UIColor.color707070,
                            opacity: 0.5,
                            offset: CGSize(width: 0, height: 0),
                            radius: 10.0)

    gasFeeLabel.numberOfLines = 0
    gasFeeLabel.text = "0 \(currentWallet.symbol)" + " ~ 0 \(DataProvider.shared.defaultEx ?? "$")"

    toLabel.text = to

    amountLabel.text = amount + " \(currentWallet.symbol)"

    coinValueLabel.text = "\(value) \(currentWallet.symbol)"

    if currentWallet.symbol == Coins.ethereum.symbol() {
      gasFee = Double(Web3Service.getLocalGasPrice())
    }
  }

  func refreshView() {

    let feeBigInt = (EthereumQuantity(quantity: Int(gasFee).gwei))

    let gasFee = getGasFee(feeBigInt.quantity)

    let feeEth = getETHFormat(from: gasFee)

    let feeFiat = getCost(from: "\(feeEth)")

    self.gasFeeLabel.text = "\(feeEth)" + " \(currentWallet.symbol)" + " ~ \(feeFiat.formattedAmount!) \(DataProvider.shared.defaultEx ?? "$")"
    let value = self.getAmountAfterRemoveFee(feeBigInt.quantity)
    self.coinValueLabel.text = "\(value) \(currentWallet.symbol)"

  }

  func getETHFormat(from: BigUInt) -> Decimal {
    guard let value =  Web3Utils.formatToEthereumUnits(from,
                                                       toUnits: .eth,
                                                       decimals: 18,
                                                       decimalSeparator: ".") else { return 0 }
    return Decimal(string: value)!
  }

  func getBigUInt(from eth: String) -> BigUInt {
    guard let value =  Web3Utils.parseToBigUInt(eth, units: .eth) else { return 0}
    return value
  }

  func getAmountAfterRemoveFee(_ gasPrice: BigUInt) -> Decimal {
    let gas = getGasFee(gasPrice)
    let amountBigInt = getBigUInt(from: self.amount)
    let newEthAmount = amountBigInt - gas
    self.value = newEthAmount
    return getETHFormat(from: newEthAmount)
  }

  func getGasFee(_ gasPrice: BigUInt) -> BigUInt {
    return gasPrice * currentWallet.gasLimit
  }

  fileprivate func getCost(from value: String) -> Decimal {
    guard Double(value) != nil else { return 0 }
    let balance = Double(value)! * fee
    return Decimal(balance)
  }

  // MARK: - Actions
  @IBAction func gasTapped(_ sender: UISegmentedControl) {
    guard let gas = gasModel else { return }

    switch sender.selectedSegmentIndex {
      case 0:
        gasFee = Double(gas.safeGasPrice)!
      case 1:
        gasFee = Double(gas.proposeGasPrice)!
      case 2:
        gasFee = Double(gas.fastGasPrice)!
      default:
        break
    }

    self.refreshView()

  }

  @IBAction func confirmTapped(_ sender: UIButton) {

    currentWallet.send(to,
                       amount: value,
                       gasPrice: BigUInt(gasFee)) { [weak self](txHash) in
      guard let self = self else { return }

      if txHash.hasPrefix("0x") {
        let viewController = UIStoryboard.transaction.instantiate(viewController: TransactionReciptVC.self)

        let value = self.getETHFormat(from: self.value)
        let fiatValue = self.getCost(from: "\(value)")
        let fiatFormat = "\(fiatValue.formattedAmount ?? "0") \(DataProvider.shared.defaultEx ?? "$")"
        guard let wallet = self.wallet else { return }

        viewController.initWith(self.to,
                                amount: value,
                                amountFiat: fiatFormat,
                                coin: wallet.name,
                                txHash: txHash, wallet: wallet)
        self.navigationController?.pushViewController(viewController, animated: false)
      } else {
        KVNProgress.showError(withStatus: txHash)
      }
    }
  }

  @IBAction func closeTapped(_ sender: UIButton) {
    dismiss(animated: true)
  }

}

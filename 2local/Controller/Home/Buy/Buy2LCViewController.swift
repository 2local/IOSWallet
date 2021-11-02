//
//  Buy2LCViewController.swift
//  2local
//
//  Created by Hasan Sedaghat on 1/2/20.
//  Copyright © 2020 2local Inc. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import KVNProgress
class Buy2LCViewController: BaseVC, UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var amountTXF: SkyFloatingLabelTextField!
    @IBOutlet var paymentMethodBTN: UIButton!
    @IBOutlet var costLabel: UILabel!
    @IBOutlet var currencyLabel: UILabel! {
        didSet {
            currencyLabel.text = DataProvider.shared.defaultEx
        }
    }
    @IBOutlet var tableViewHeight: NSLayoutConstraint! {
        didSet {
            tableViewHeight.constant = 0
        }
    }
    @IBOutlet var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.layer.borderWidth = 1
        }
    }
    

    var paymentMethods = [Coins.Bitcoin.rawValue, Coins.Ethereum.rawValue, Coins.Stellar.rawValue]
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.tapToDismissKeyboard()
        self.amountTXF.addTarget(self, action: #selector(amountCalculation), for: .editingChanged)
        self.paymentMethodBTN.setTitle(paymentMethods.first, for: .normal)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paymentMethods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "paymentMethod") as! PaymentMethodTableViewCell
        cell.titleLabel.text = paymentMethods[indexPath.row]
        tableView.layer.borderColor = UIColor._F6F6F9.cgColor
        if paymentMethods[indexPath.row] == paymentMethodBTN.titleLabel?.text {
            cell.backgroundColor = UIColor._F6F6F9
            cell.titleLabel.textColor = UIColor._303030
        }
        else {
            if #available(iOS 13.0, *) {
                cell.backgroundColor = .systemBackground
            } else {
                cell.backgroundColor = .white
            }
            cell.titleLabel.textColor = UIColor._606060
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.paymentMethodBTN.setTitle(self.paymentMethods[indexPath.row], for: .normal)
        
        UIView.animate(withDuration: 0.25, animations: {
            self.tableView.alpha = 0
        }) { finish in
            self.tableViewHeight.constant = 0
        }
        
    }
    
    @objc func amountCalculation() {
        //if !calculationActive {
        //self.calculationActive = true
        UIView.transition(with: self.costLabel, duration: 0.3, options: .transitionFlipFromTop, animations: {
            self.costLabel.text = "\(Balance.monetaryValue(amount: self.amountTXF.text?.toEnglishFormat()))".convertToPriceType()
        }) { (finish) in
            //self.calculationActive = false
        }
        //}
    }
    
    @IBAction func paymentMethod(_ sender: Any) {
        if tableView.alpha == 0 {
            self.tableView.reloadData()
            self.tableView.alpha = 1
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
                self.tableViewHeight.constant = CGFloat(46 * self.paymentMethods.count)
                self.view.layoutSubviews()
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    @IBAction func buy(_ sender: Any) {
        if self.amountTXF.text != "" {
            KVNProgress.show()
            let stringCost = "\(Float(self.amountTXF.text ?? "0.0")! * Float(DataProvider.shared.exchangeRate?.defaultExR ?? "0.0")!)"
            let floatCost = Float(stringCost)!
            let finalCost = Double(String(format: "%.2f", ceil(floatCost*100)/100))!
            if finalCost >= 2.50 {
                let l2lQuantity = Double(self.amountTXF.text!.toEnglishFormat())!
                if self.paymentMethodBTN.titleLabel?.text == "PayPal" {
                    APIManager.shared.mollie(userId: DataProvider.shared.user!.id ?? -1, quantity: finalCost, currency: DataProvider.shared.defaultEx!, amount: finalCost, paymentType: "paypal",l2lQuantity: l2lQuantity) { (data, response, error) in
                        if data != nil && error == nil {
                            var link = String(data: data!, encoding: .utf8)!.replacingOccurrences(of: "\\", with: "")
                            link.removeFirst()
                            link.removeLast()
                            DispatchQueue.main.async {
                                if UIApplication.shared.canOpenURL((link.getCleanedURL())!) {
                                    KVNProgress.dismiss {
                                        UIApplication.shared.open((link.getCleanedURL())!, options: [:], completionHandler: nil)
                                    }
                                }
                                else {
                                    KVNProgress.showError(withStatus: "Can not open the link\nPlease contact us")
                                }
                            }
                        }
                        else {
                            DispatchQueue.main.async {
                                KVNProgress.showError(withStatus: error.debugDescription)
                            }
                        }
                    }
                }
                else {
                    APIManager.shared.addOrder(userId: DataProvider.shared.user!.id ?? -1, quantity: finalCost, currency: DataProvider.shared.defaultEx!, amount: finalCost, status: "open", date: Date().description, paymentType: self.paymentMethodBTN.titleLabel!.text!.lowercased(), l2lQuantity: l2lQuantity) { (data, response, error) in
                        let result = APIManager.processResponse(response: response, data: data)
                        if result.status {
                            do {
                                if let order = try JSONDecoder().decode(ResultData<AddOrderModel>.self, from: data!).record {
                                    
//                                    guard let firstRecord = order.firstRecord, let walletNumber = firstRecord.btc ?? firstRecord.eth ?? firstRecord.stellar else { return }
                                    
                                    DispatchQueue.main.async {
                                        KVNProgress.dismiss {
                                            self.performSegue(withIdentifier: "goToBtcMode", sender: finalCost)
                                        }
                                    }
                                }
                                else {
                                    DispatchQueue.main.async {
                                        KVNProgress.showError(withStatus: "Failed to parse data\nPlease contact us.")
                                    }
                                }
                            }
                            catch {
                                DispatchQueue.main.async {
                                    KVNProgress.showError(withStatus: "Failed to parse data\nPlease contact us.")
                                }
                            }
                        }
                        else {
                            DispatchQueue.main.async {
                                KVNProgress.showError(withStatus: result.message)
                            }
                        }
                    }
                }
            }
            else {
                KVNProgress.showError(withStatus: "2LC total price must be more than 2.5\(DataProvider.shared.defaultEx ?? "USD")")
            }
        }
        else {
            KVNProgress.showError(withStatus: "Amount field is empty\nPlease fill it")
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToBtcMode" {
            
            let navVC = segue.destination as! UINavigationController
            let destVC = navVC.children.first as! Buy2LCReceiptViewController
            destVC.price = "\(sender as! Double)"
            var btcAmount = (sender as! Double) / ((DataProvider.shared.exchangeRate?.bitcoin?.defaultExchangeRate)! as NSDecimalNumber).doubleValue
            
            if self.paymentMethodBTN.titleLabel?.text == "Stellar" {
                btcAmount = (sender as! Double) / ((DataProvider.shared.exchangeRate?.stellar?.defaultExchangeRate)! as NSDecimalNumber).doubleValue
                destVC.type = "XLM"
                destVC.walletNumber = DataProvider.shared.stellarWalletNumber
            }
            else if self.paymentMethodBTN.titleLabel?.text == "Ethereum" {
                btcAmount = (sender as! Double) / ((DataProvider.shared.exchangeRate?.ethereum?.defaultExchangeRate)! as NSDecimalNumber).doubleValue
                destVC.type = "ETH"
                destVC.walletNumber = DataProvider.shared.etheriumWalletNumber
            }
            else {
                btcAmount = (sender as! Double) / ((DataProvider.shared.exchangeRate?.bitcoin?.defaultExchangeRate)! as NSDecimalNumber).doubleValue
                destVC.type = "BTC"
                destVC.walletNumber = DataProvider.shared.bitcoinWalletNumber
            }
            destVC.amount = "\(btcAmount)"
            
//            let navVC = segue.destination as! UINavigationController
//            let destVC = navVC.children.first as! Buy2LCReceiptViewController
//            destVC.price = "\(sender as! Double)"
//            var btcAmount = (sender as! Double) / ((DataProvider.shared.exchangeRate?.bitcoin?.defaultExchangeRate)! as NSDecimalNumber).doubleValue
//
//            guard let walletNumber = self.walletNumber else { return  }
//
//            if self.paymentMethodBTN.titleLabel?.text == "Stellar" {
//                btcAmount = (sender as! Double) / ((DataProvider.shared.exchangeRate?.stellar?.defaultExchangeRate)! as NSDecimalNumber).doubleValue
//                destVC.type = "XLM"
//            }
//            else if self.paymentMethodBTN.titleLabel?.text == "Ethereum" {
//                btcAmount = (sender as! Double) / ((DataProvider.shared.exchangeRate?.ethereum?.defaultExchangeRate)! as NSDecimalNumber).doubleValue
//                destVC.type = "ETH"
//            }
//            else {
//                btcAmount = (sender as! Double) / ((DataProvider.shared.exchangeRate?.bitcoin?.defaultExchangeRate)! as NSDecimalNumber).doubleValue
//                destVC.type = "BTC"
//            }
//
//            destVC.walletNumber = walletNumber
//            destVC.amount = "\(btcAmount)"
        }
    }
    
}

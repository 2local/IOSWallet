//
//  PaymentConfirmationViewController.swift
//  2local
//
//  Created by Hasan Sedaghat on 1/1/20.
//  Copyright © 2020 2local Inc. All rights reserved.
//

import UIKit
import KVNProgress
class PaymentConfirmationViewController: BaseVC {
    
    @IBOutlet var walletNumberLabel: UILabel!
    @IBOutlet var costLable: UILabel!
    @IBOutlet var amountLabel: UILabel!
    
    var qrStringData = ""
    var amount = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.parent?.view.setShadow(color: UIColor._002CA4, opacity: 0.1, offset: CGSize(width: 0, height: -3), radius: 10)
        let stringData  = qrStringData.split(separator: ",")
        if stringData.count == 2 {
            walletNumberLabel.text = stringData.first?.description
            amount = stringData.last?.description ?? "0"
            let cost = Balance.monetaryValue(amount: amount)
            amountLabel.text = (amount.convertToPriceType()) + " " + "2LC"
            costLable.text = (DataProvider.shared.exchangeRate?.defaultSym ?? "") + "\(cost)".convertToPriceType()
        }
        else {
            KVNProgress.showError(withStatus: "Qr code format is not valid") {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func confirm(_ sender: Any) {
        //checkTrust()
        self.transfer()
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func close(_ sender: Any) {
        self.performSegue(withIdentifier: "goToHome", sender: nil)
    }
    
    func checkTrust() {
        KVNProgress.show()
        APIManager.shared.checkTrust(publicKey: "nil", issuer: DataProvider.shared.issuer) { (data, response, error) in
         let result = APIManager.processResponse(response: response, data: data)
            if result.status {
                self.transfer()
            }
            else {
                DispatchQueue.main.async {
                    KVNProgress.showError(withStatus: result.message)
                }
            }
        }
    }
    
    func transfer() {
        KVNProgress.show()
        APIManager.shared.transfer(amount: (self.amount), walletNumber: (self.walletNumberLabel.text)!) { (data, response, error) in
            let result = APIManager.processResponse(response: response, data: data)
            if result.status {
                self.getBalance()
                self.getTransferOrder()
                DispatchQueue.main.async {
                    KVNProgress.dismiss {
                        self.performSegue(withIdentifier: "goToReceipt", sender: nil)
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
    
    func getTransferOrder() {
        APIManager.shared.getTransferOrderDetail(userId: "\(DataProvider.shared.user!.id ?? 0)") { (data, response, error) in
            let result = APIManager.processResponse(response: response, data: data)
            if result.status {
                do {
                    let transfers = try JSONDecoder().decode(ResultData<[Transfer]>.self, from: data!).record
                    DataProvider.shared.transfers = (transfers?.map({ (transfer) -> Transfer in
                        var localTransfer = transfer
                        localTransfer.source = localTransfer.source!.lowercased()
                        return localTransfer
                    }))!
                    
                    DataProvider.shared.transfers = transfers!
                }
                catch {
                    DispatchQueue.main.async {
                        KVNProgress.showError(withStatus: "Failed to parse transfers history data\nPlease contact us.")
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
    
    func getBalance() {/*
        guard let user = DataProvider.shared.user, let publicKey = user.publicKey, let email = user.email else { return }
        APIManager.shared.getBalance(publicKey: publicKey, email: email) { (data, response, error) in
            let result = APIManager.processResponse(response: response, data: data)
            if result.status {
                do {
                    let balance = try JSONDecoder().decode(ResultData<Balance>.self, from: data!).record?.balance
                    DataProvider.shared.user?.balance = balance
                }
                catch {
                    DispatchQueue.main.async {
                        KVNProgress.showError(withStatus: "Failed to parse balance data\nPlease contact us.")
                    }
                }
            }
            else {
                DispatchQueue.main.async {
                    KVNProgress.showError(withStatus: result.message)
                }
            }
        }*/
    }
}

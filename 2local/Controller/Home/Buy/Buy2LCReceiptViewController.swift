//
//  Buy2LCReceiptViewController.swift
//  2local
//
//  Created by Hasan Sedaghat on 1/3/20.
//  Copyright © 2020 2local Inc. All rights reserved.
//

import UIKit
import KVNProgress

class Buy2LCReceiptViewController: BaseVC {

    @IBOutlet var qrCode: UIImageView! {
        didSet {
            qrCode.setCornerRadius(5)
            qrCode.image = generateQRCode(from: walletNumber)
        }
    }
    @IBOutlet var btcWalletNumberLabel: UILabel! {
        didSet {
            btcWalletNumberLabel.text = walletNumber
        }
    }
    @IBOutlet var amountLabel: UILabel! {
        didSet {
            amount = String(format: "%.6f", ceil(Double(amount)! * 1000000.0)/1000000.0)
            amountLabel.text = "\(amount) \(type)"
        }
    }
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var priceLabel: UILabel! {
        didSet {
            priceLabel.text = "~ $\(price)"
        }
    }
    @IBOutlet var copyAmountBTN: TLButton! {
        didSet {
            copyAmountBTN.layer.borderColor = UIColor.flamenco.cgColor
            copyAmountBTN.layer.borderWidth = 1
            copyAmountBTN.layer.cornerRadius = 8
        }
    }

    @IBOutlet var coinWalletTitle: UILabel! {
        didSet {
            coinWalletTitle.text = "\(type) wallet address"
        }
    }
    var amount = ""
    var price = ""
    var type = ""
    var walletNumber = ""
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func copyAddress(_ sender: Any) {
        UIPasteboard.general.string = self.btcWalletNumberLabel.text
        KVNProgress.showSuccess(withStatus: "Wallet number copied to clipboard")
    }

    @IBAction func copyAmount(_ sender: Any) {
        UIPasteboard.general.string = String(format: "%.6f", ceil(Double(amount)! * 1000000.0)/1000000.0)
        KVNProgress.showSuccess(withStatus: "Wallet number copied to clipboard")
    }

    @IBAction func closeLabel(_ sender: Any) {
        self.performSegue(withIdentifier: "goHome", sender: nil)
    }
}

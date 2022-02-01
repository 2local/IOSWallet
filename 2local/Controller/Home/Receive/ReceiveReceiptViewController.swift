//
//  ReceiveReceiptViewController.swift
//  2local
//
//  Created by Hasan Sedaghat on 1/1/20.
//  Copyright © 2020 2local Inc. All rights reserved.
//

import UIKit

class ReceiveReceiptViewController: BaseVC {

    @IBOutlet var qrCodeIMG: UIImageView! {
        didSet {
            qrCodeIMG.setCornerRadius(5)
            qrCodeIMG.image = generateQRCode(from: walletNumber)
        }
    }

    @IBOutlet var walletLabel: UILabel! {
        didSet {
            walletLabel.text = walletNumber
        }
    }
    @IBOutlet var amountLabel: UILabel! {
        didSet {
            amountLabel.text = amount
        }
    }
    @IBOutlet var costLabel: UILabel! {
        didSet {
            costLabel.text = "~ \(DataProvider.shared.exchangeRate?.defaultSym ?? "$")\(cost)"
        }
    }
    @IBOutlet var popUpView: UIView!
    @IBOutlet weak var walletSymbolLabel: UILabel! {
        didSet {
            walletSymbolLabel.text = walletTypeName.symbol()
        }
    }

    // MARK: - properties
    private var walletNumber = ""
    private var amount = ""
    private var cost = ""
    private var walletTypeName: Coins = .tLocal

    func initWith(_ walletNumber: String, amount: String, cost: String, walletTypeName: Coins) {
        self.walletNumber = walletNumber
        self.amount = amount
        self.cost = cost
        self.walletTypeName = walletTypeName
    }

    // MARK: - view cycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func share(_ sender: Any) {
        let text = walletNumber
        let textShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textShare as [Any], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }

    @IBAction func close(_ sender: Any) {
        performSegue(withIdentifier: "goToHome", sender: nil)
    }

}

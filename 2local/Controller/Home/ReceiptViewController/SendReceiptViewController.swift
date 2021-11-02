//
//  SendReceiptViewController.swift
//  2local
//
//  Created by Hasan Sedaghat on 1/1/20.
//  Copyright © 2020 2local Inc. All rights reserved.
//

import UIKit

class SendReceiptViewController: BaseVC {

    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var costLabel: UILabel!
    @IBOutlet var walletNumberLabel: UILabel! {
        didSet {
            walletNumberLabel.text = walletNumber
        }
    }
    
    var walletNumber = ""
    var amount = ""
    var cost = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.parent?.view.setShadow(color: UIColor._002CA4, opacity: 0.1, offset: CGSize(width: 0, height: -3), radius: 10)
        self.amountLabel.text = "\(amount) 2LC"
        self.costLabel.text = "\(cost)".convertToPriceType() + "\(DataProvider.shared.defaultEx!)"
    }

    @IBAction func done(_ sender: Any) {
        performSegue(withIdentifier: "goToHome", sender: nil)
    }
}

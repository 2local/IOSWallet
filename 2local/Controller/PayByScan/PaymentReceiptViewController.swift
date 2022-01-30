//
//  PaymentReceiptViewController.swift
//  2local
//
//  Created by Hasan Sedaghat on 1/1/20.
//  Copyright © 2020 2local Inc. All rights reserved.
//

import UIKit

class PaymentReceiptViewController: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.parent?.view.setShadow(color: UIColor.color002CA4, opacity: 0.1, offset: CGSize(width: 0, height: -3), radius: 10)
    }

    @IBAction func close(_ sender: Any) {
        self.performSegue(withIdentifier: "goToHome", sender: nil)
    }

}

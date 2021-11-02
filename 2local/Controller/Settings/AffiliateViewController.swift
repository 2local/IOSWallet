//
//  AffiliateViewController.swift
//  2local
//
//  Created by Hasan Sedaghat on 1/8/20.
//  Copyright © 2020 2local Inc. All rights reserved.
//

import UIKit
import KVNProgress
class AffiliateViewController: BaseVC {

    @IBOutlet var shareBTN: TLButton! {
        didSet {
            shareBTN.layer.borderColor = UIColor._flamenco.cgColor
            shareBTN.layer.borderWidth = 1
        }
    }
    @IBOutlet var linkLabel: UILabel! {
        didSet {
            linkLabel.numberOfLines = 0
            linkLabel.text = "https://sec.2local.io/register?hope=\(DataProvider.shared.user?.affiliateCode ?? "0") "
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func copyLink(_ sender: Any) {
        UIPasteboard.general.string = linkLabel.text
        KVNProgress.showSuccess(withStatus: "Refferal link copied to clipboard")
    }
    
    @IBAction func share(_ sender: Any) {
        let text = linkLabel.text
        let textShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textShare as [Any] , applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
}

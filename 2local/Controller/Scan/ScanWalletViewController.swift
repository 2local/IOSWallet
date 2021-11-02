//
//  ScanWalletViewController.swift
//  2local
//
//  Created by Hasan Sedaghat on 1/5/20.
//  Copyright © 2020 2local Inc. All rights reserved.
//

import UIKit

protocol ScanWalletNumberDelegate: AnyObject {
    func walletDidScan(str:String?)
}

class ScanWalletViewController: ScanViewController {
    
    weak var delegate : ScanWalletNumberDelegate?
    
    override func qrScanningSucceededWithCode(_ str: String?) {
        self.dismiss(animated: true) {
            self.delegate?.walletDidScan(str: str)
        }
    }

}

//
//  TwoFAControlViewController.swift
//  2local
//
//  Created by Hasan Sedaghat on 1/22/20.
//  Copyright © 2020 2local Inc. All rights reserved.
//

import UIKit
import KVNProgress
class TwoFAControlViewController: BaseVC {

    @IBOutlet var twoFABTN: UIButton! {
        didSet {
            if let user = user, (user.twofaStatus ?? false) == false {
                twoFABTN.backgroundColor = ._shamrock
                twoFABTN.setTitle("Enable 2FA", for: .normal)
            }
            else {
                twoFABTN.backgroundColor = ._bittersweet
                twoFABTN.setTitle("Disable 2FA", for: .normal)
            }
        }
    }
    let user = DataProvider.shared.user
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func twoFA(_ sender: Any) {
        
        if user?.twofaStatus == false {
            user?.twofaStatus = true
            UIView.transition(with: self.twoFABTN, duration: 0.2, options: .transitionCrossDissolve, animations: {
                self.twoFABTN.backgroundColor = ._bittersweet
                self.twoFABTN.setTitle("Disable 2FA", for: .normal)
            }, completion: nil)
        }
        else if user?.twofaStatus == true {
            user?.twofaStatus = false
            UIView.transition(with: self.twoFABTN, duration: 0.2, options: .transitionCrossDissolve, animations: {
                self.twoFABTN.backgroundColor = ._shamrock
                self.twoFABTN.setTitle("Enable 2FA", for: .normal)
            }, completion: nil)
        }
        APIManager.shared.updateProfile(name: user?.name ?? "" ,
                                        email: user?.email ?? "",
                                        mobileNumber: "\(user?.mobileNumber ?? "0")",
                                        firstName: user?.firstName ?? "",
                                        lastName: user?.lastName ?? "",
                                        birthday: "",
                                        countryCode:  "\(user?.countryCode ?? "-1")",
                                        country: user?.country ?? "",
                                        city: user?.city ?? "",
                                        state: user?.state ?? "",
                                        postCode: "",
                                        address: user?.address ?? "",
                                        password: "",
                                        image: nil,
                                        userId: DataProvider.shared.user!.id!,
                                        twofaStatus: user?.twofaStatus ?? false) { (data, response, error) in
            let result = APIManager.processResponse(response: response, data: data)
            if result.status {
                DataProvider.shared.user = self.user
            }
            else {
                DispatchQueue.main.async {
                    KVNProgress.showError(withStatus: result.message)
                }
            }
        }
    }
    
}

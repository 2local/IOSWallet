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
        twoFABTN.backgroundColor = .shamrock
        twoFABTN.setTitle("Enable 2FA", for: .normal)
      } else {
        twoFABTN.backgroundColor = .bittersweet
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
        self.twoFABTN.backgroundColor = .bittersweet
        self.twoFABTN.setTitle("Disable 2FA", for: .normal)
      }, completion: nil)
    } else if user?.twofaStatus == true {
      user?.twofaStatus = false
      UIView.transition(with: self.twoFABTN, duration: 0.2, options: .transitionCrossDissolve, animations: {
        self.twoFABTN.backgroundColor = .shamrock
        self.twoFABTN.setTitle("Enable 2FA", for: .normal)
      }, completion: nil)
    }

    let name = user?.name ?? ""
    let email = user?.email ?? ""
    let mobileNumber = "\(user?.mobileNumber ?? "0")"
    let firstName = user?.firstName ?? ""
    let lastName = user?.lastName ?? ""
    let birthday = ""
    let countryCode = "\(user?.countryCode ?? "-1")"
    let country = user?.country ?? ""
    let city = user?.city ?? ""
    let state = user?.state ?? ""
    let postCode = ""
    let address = user?.address ?? ""
    let password = ""
    let image = Data()
    let userId = DataProvider.shared.user!.id!
    let twofaStatus = user?.twofaStatus ?? false

    let parameters = "name=\(name)&email=\(email)&mobile_number=\(mobileNumber)&" +
    "first_name=\(firstName)&last_name=\(lastName)&" +
    "birthday=\(birthday)&country=\(country)&country_code=\(countryCode)&" +
    "city=\(city)&state=\(state)&post_code=\(postCode)&" +
    "address=\(address)&password=\(password)&" +
    "user_id=\(userId)&image=\(image)&twofa_status=\(twofaStatus)"

    APIManager.shared.updateProfile(parameter: parameters) { (data, response, _) in
      let result = APIManager.processResponse(response: response, data: data)
      if result.status {
        DataProvider.shared.user = self.user
      } else {
        DispatchQueue.main.async {
          KVNProgress.showError(withStatus: result.message)
        }
      }
    }
  }

}

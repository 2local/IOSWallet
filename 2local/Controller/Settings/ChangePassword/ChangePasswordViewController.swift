//
//  ChangePasswordViewController.swift
//  2local
//
//  Created by Hasan Sedaghat on 1/9/20.
//  Copyright © 2020 2local Inc. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import KVNProgress
class ChangePasswordViewController: BaseVC {

  @IBOutlet var scrollView: UIScrollView!
  @IBOutlet var currentPassword: SkyFloatingLabelTextField! {
    didSet {
      currentPassword.titleFont = .TLFont(weight: .medium,
                                          size: 12)
      currentPassword.placeholderFont = .TLFont()
      currentPassword.font = .TLFont()
    }
  }
  @IBOutlet var newPassword: SkyFloatingLabelTextField! {
    didSet {
      newPassword.titleFont = .TLFont(weight: .medium,
                                      size: 12)
      newPassword.placeholderFont = .TLFont()
      newPassword.font = .TLFont()
    }
  }
  @IBOutlet var repeatNewPassword: SkyFloatingLabelTextField! {
    didSet {
      repeatNewPassword.titleFont = .TLFont(weight: .medium,
                                            size: 12)
      repeatNewPassword.placeholderFont = .TLFont()
      repeatNewPassword.font = .TLFont()
    }
  }

  let user = DataProvider.shared.user

  override func viewDidLoad() {
    self.view.tapToDismissKeyboard()
    self.scrollView.handleKeyboard()
  }

  @IBAction func changePassword(_ sender: Any) {
    if currentPassword.text == DataProvider.shared.keychain.get("sp") /*|| currentPassword.text == user?.password*/ {
      if newPassword.text == repeatNewPassword.text {
        KVNProgress.show()

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
        let password = self.newPassword.text ?? ""
        let image = Data()
        let userId = DataProvider.shared.user!.id!
        let twofaStatus = user!.twofaStatus ?? false

        let parameters = "name=\(name)&email=\(email)&mobile_number=\(mobileNumber)&" +
        "first_name=\(firstName)&last_name=\(lastName)&" +
        "birthday=\(birthday)&country=\(country)&country_code=\(countryCode)&" +
        "city=\(city)&state=\(state)&post_code=\(postCode)&" +
        "address=\(address)&password=\(password)&" +
        "user_id=\(userId)&image=\(image)&twofa_status=\(twofaStatus)"

        APIManager.shared.updateProfile(parameter: parameters) { (data, response, _) in
          let result = APIManager.processResponse(response: response, data: data)
          if result.status {
            DataProvider.shared.keychain.set(self.newPassword.text!, forKey: "sp")
            DataProvider.shared.user = self.user
            DispatchQueue.main.async {
              KVNProgress.dismiss {
                self.performSegue(withIdentifier: "goToResult", sender: nil)
              }
            }
          } else {
            DispatchQueue.main.async {
              KVNProgress.showError(withStatus: result.message)
            }
          }
        }
      } else {
        KVNProgress.showError(withStatus: "New Password fields doesn't match")
      }
    } else {
      KVNProgress.showError(withStatus: "Current password is incorrect")
    }
  }
}

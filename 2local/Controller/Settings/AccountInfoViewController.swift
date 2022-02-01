//
//  AccountInfoViewController.swift
//  2local
//
//  Created by Hasan Sedaghat on 1/7/20.
//  Copyright © 2020 2local Inc. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import KVNProgress
class AccountInfoViewController: BaseVC, UIPickerViewDelegate, UITextFieldDelegate {

  @IBOutlet var usernameTXF: SkyFloatingLabelTextField! {
    didSet {
      usernameTXF.titleFont = .TLFont(weight: .medium,
                                      size: 12)
      usernameTXF.placeholderFont = .TLFont()
      usernameTXF.font = .TLFont()
      usernameTXF.text = user?.name ?? ""
    }
  }
  @IBOutlet var phoneTXF: SkyFloatingLabelTextField! {
    didSet {
      phoneTXF.titleFont = .TLFont(weight: .medium,
                                   size: 12)
      phoneTXF.placeholderFont = .TLFont()
      phoneTXF.font = .TLFont()
      phoneTXF.text = "\(user?.mobileNumber ?? "0")"
    }
  }
  @IBOutlet var emailTXF: SkyFloatingLabelTextField! {
    didSet {
      emailTXF.titleFont = .TLFont(weight: .medium,
                                   size: 12)
      emailTXF.placeholderFont = .TLFont()
      emailTXF.font = .TLFont()
      emailTXF.text = user?.email ?? ""
    }
  }
  @IBOutlet var firstNameTXF: SkyFloatingLabelTextField! {
    didSet {
      firstNameTXF.titleFont = .TLFont(weight: .medium,
                                       size: 12)
      firstNameTXF.placeholderFont = .TLFont()
      firstNameTXF.font = .TLFont()
      firstNameTXF.text = user?.firstName ?? ""
    }
  }
  @IBOutlet var lastNameTXF: SkyFloatingLabelTextField! {
    didSet {
      lastNameTXF.titleFont = .TLFont(weight: .medium,
                                      size: 12)
      lastNameTXF.placeholderFont = .TLFont()
      lastNameTXF.font = .TLFont()
      lastNameTXF.text = user?.lastName ?? ""
    }
  }
  @IBOutlet var birthDayTXF: SkyFloatingLabelTextField! {
    didSet {
      birthDayTXF.titleFont = .TLFont(weight: .medium,
                                      size: 12)
      birthDayTXF.placeholderFont = .TLFont()
      birthDayTXF.font = .TLFont()
      birthDayTXF.text = ""
      birthDayTXF.delegate = self
      birthDayTXF.inputView = picker
    }
  }
  @IBOutlet var countryTXF: SkyFloatingLabelTextField! {
    didSet {
      countryTXF.titleFont = .TLFont(weight: .medium,
                                     size: 12)
      countryTXF.placeholderFont = .TLFont()
      countryTXF.font = .TLFont()
      countryTXF.text = user?.country ?? ""
    }
  }
  @IBOutlet var stateTXF: SkyFloatingLabelTextField! {
    didSet {
      stateTXF.titleFont = .TLFont(weight: .medium,
                                   size: 12)
      stateTXF.placeholderFont = .TLFont()
      stateTXF.font = .TLFont()
      stateTXF.text = user?.state ?? ""
    }
  }
  @IBOutlet var cityTXF: SkyFloatingLabelTextField! {
    didSet {
      cityTXF.titleFont = .TLFont(weight: .medium,
                                  size: 12)
      cityTXF.placeholderFont = .TLFont()
      cityTXF.font = .TLFont()
      cityTXF.text = user?.city ?? ""
    }
  }
  @IBOutlet var addressTXF: SkyFloatingLabelTextField! {
    didSet {
      addressTXF.titleFont = .TLFont(weight: .medium,
                                     size: 12)
      addressTXF.placeholderFont = .TLFont()
      addressTXF.font = .TLFont()
      addressTXF.text = user?.address ?? ""
    }
  }
  @IBOutlet var postalCodeTXF: SkyFloatingLabelTextField! {
    didSet {
      postalCodeTXF.titleFont = .TLFont(weight: .medium,
                                        size: 12)
      postalCodeTXF.placeholderFont = .TLFont()
      postalCodeTXF.font = .TLFont()
      postalCodeTXF.text = ""
    }
  }

  @IBOutlet var scrollView: UIScrollView!

  var user = DataProvider.shared.user
  var isKeyboardOn = false
  var picker = UIDatePicker()

  override func viewDidLoad() {
    super.viewDidLoad()

    self.view.tapToDismissKeyboard()

    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    picker.datePickerMode = .date
    picker.maximumDate = Date() - 5000
    picker.addTarget(self, action: #selector(datePickerDidChange), for: .valueChanged)
    picker.calendar = Calendar(identifier: .gregorian)
    picker.timeZone = TimeZone(abbreviation: "GMT")

  }

  deinit {
    NotificationCenter.default.removeObserver(self)
  }

  @objc func datePickerDidChange() {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd/MM/yyyy"
    let strDate = dateFormatter.string(from: picker.date)
    self.birthDayTXF.text = strDate
  }

  @objc
  func keyboardWillShow(notification: NSNotification) {
    guard let keyboardFrame: CGRect = (notification.userInfo![UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue else { return }
    var contentInset: UIEdgeInsets = self.scrollView.contentInset
    if !isKeyboardOn {
      isKeyboardOn = true
      contentInset.bottom += keyboardFrame.height
    }
    self.scrollView.contentInset = contentInset
    // let a = self.scrollView.subviews.first?.subviews.map({($0).superclass === UITextField.self && ($0).isFirstResponder})

    let subViewPoint = self.scrollView.subviews.first?.subviews.map({ (view) -> CGPoint? in
      if view.superclass === UITextField.self && view.isFirstResponder {
        return view.frame.origin
      }
      return nil
    })
    if let filter = subViewPoint?.filter({$0 != nil}) {
      let height = ((filter.first??.y)! - keyboardFrame.height)
      if height > 0 {
        self.scrollView.setContentOffset(CGPoint(x: 0, y: height ), animated: false)
      }
    }
  }
  @objc func keyboardWillHide(notification: NSNotification) {
    self.scrollView.contentInset.bottom = CGFloat(0)
    isKeyboardOn = false
  }
  var isProfileIMGSelected = false
  @IBAction func updateProfile(_ sender: Any) {
    let name = usernameTXF.text == "" ? "" : usernameTXF.text
    let email = emailTXF.text == "" ? "" : emailTXF.text
    let mobileNumber = phoneTXF.text == "" ? "" : phoneTXF.text
    let firstName = firstNameTXF.text == "" ? "" : firstNameTXF.text
    let lastName = lastNameTXF.text == "" ? "" : lastNameTXF.text
    let birthday = birthDayTXF.text == "" ? "" : birthDayTXF.text
    let countryCode = "\(user?.countryCode ?? "-1")"
    let country = countryTXF.text == "" ? "" : countryTXF.text
    let city = cityTXF.text == "" ? "" : cityTXF.text
    let state = stateTXF.text == "" ? "" : stateTXF.text
    let postCode = postalCodeTXF.text == "" ? "" : postalCodeTXF.text
    let address = addressTXF.text == "" ? "" : addressTXF.text
    let password = ""
    let image = isProfileIMGSelected ? Data() : nil
    let userId = DataProvider.shared.user!.id!
    let twofaStatus = user!.twofaStatus ?? false
    let parameters = "name=\(name)&email=\(email)&mobile_number=\(mobileNumber)&" +
    "first_name=\(firstName)&last_name=\(lastName)&" +
    "birthday=\(birthday)&country=\(country)&country_code=\(countryCode)&" +
    "city=\(city)&state=\(state)&post_code=\(postCode)&" +
    "address=\(address)&password=\(password)&" +
    "user_id=\(userId)&image=\(image)&twofa_status=\(twofaStatus)"

    KVNProgress.show()
    APIManager.shared.updateProfile(parameter: parameters) { (data, response, _) in
      let result = APIManager.processResponse(response: response, data: data)
      if result.status {
        self.getProfile()
        DispatchQueue.main.async {
          KVNProgress.showSuccess(withStatus: result.message) {
            self.navigationController?.popViewController(animated: true)
          }
        }
      } else {
        DispatchQueue.main.async {
          KVNProgress.showError(withStatus: result.message)
        }
      }
    }
  }

  func getProfile() {
    APIManager.shared.getProfile(userId: DataProvider.shared.user?.id ?? -1) { (data, response, _) in
      let result = APIManager.processResponse(response: response, data: data)
      if result.status {
        do {
          let user = try JSONDecoder().decode(ResultData<User>.self, from: data!).record
          DataProvider.shared.user = user
        } catch {
          DispatchQueue.main.async {
            KVNProgress.showError(withStatus: "Failed to parse profile data\nPlease contact us.")
          }
        }
      } else {
        DispatchQueue.main.async {
          KVNProgress.showError(withStatus: result.message)
        }
      }
    }
  }
}

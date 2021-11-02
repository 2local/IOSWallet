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
class AccountInfoViewController: BaseVC, UIPickerViewDelegate,UITextFieldDelegate {
    
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
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        
        let keyboardFrame:CGRect = (notification.userInfo![UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        if !isKeyboardOn {
            isKeyboardOn = true
            contentInset.bottom += keyboardFrame.height
        }
        self.scrollView.contentInset = contentInset
        //let a = self.scrollView.subviews.first?.subviews.map({($0).superclass === UITextField.self && ($0).isFirstResponder})
        
        let p = self.scrollView.subviews.first?.subviews.map({ (view) -> CGPoint? in
            if view.superclass === UITextField.self && view.isFirstResponder {
                return view.frame.origin
            }
            return nil
        })
        if let fp = p?.filter({$0 != nil}) {
            let y = ((fp.first??.y)! - keyboardFrame.height)
            if y > 0 {
                self.scrollView.setContentOffset(CGPoint(x: 0, y: y ), animated: false)
            }
        }
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification){
        self.scrollView.contentInset.bottom = CGFloat(0)
        isKeyboardOn = false
    }
    
    var isProfileIMGSelected = false
    @IBAction func updateProfile(_ sender: Any) {
        
        KVNProgress.show()
        APIManager.shared.updateProfile(name: usernameTXF.text == "" ? nil : usernameTXF.text,
                                        email: emailTXF.text == "" ? nil : emailTXF.text,
                                        mobileNumber: phoneTXF.text == "" ? nil : phoneTXF.text,
                                        firstName: firstNameTXF.text == "" ? nil : firstNameTXF.text,
                                        lastName: lastNameTXF.text == "" ? nil : lastNameTXF.text,
                                        birthday: birthDayTXF.text == "" ? nil : birthDayTXF.text,
                                        countryCode: "\(user?.countryCode ?? "-1")",
                                        country: countryTXF.text == "" ? nil : countryTXF.text,
                                        city: cityTXF.text == "" ? nil : cityTXF.text,
                                        state: stateTXF.text == "" ? nil : stateTXF.text,
                                        postCode: postalCodeTXF.text == "" ? nil : postalCodeTXF.text,
                                        address: addressTXF.text == "" ? nil : addressTXF.text,
                                        password: "",
                                        image: isProfileIMGSelected ? Data() : nil,
                                        userId: DataProvider.shared.user!.id!,
                                        twofaStatus: user!.twofaStatus ?? false) { (data, response, error) in
            let result = APIManager.processResponse(response: response, data: data)
            if result.status {
                self.getProfile()
                DispatchQueue.main.async {
                    KVNProgress.showSuccess(withStatus: result.message) {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
            else {
                DispatchQueue.main.async {
                    KVNProgress.showError(withStatus: result.message)
                }
            }
        }
    }
    
    func getProfile() {
        APIManager.shared.getProfile(userId: DataProvider.shared.user?.id ?? -1) { (data, response, error) in
            let result = APIManager.processResponse(response: response, data: data)
            if result.status {
                do {
                    let user = try JSONDecoder().decode(ResultData<User>.self, from: data!).record
                    DataProvider.shared.user = user
                }
                catch {
                    DispatchQueue.main.async {
                        KVNProgress.showError(withStatus: "Failed to parse profile data\nPlease contact us.")
                    }
                }
            }
            else {
                DispatchQueue.main.async {
                    KVNProgress.showError(withStatus: result.message)
                }
            }
        }
    }
}

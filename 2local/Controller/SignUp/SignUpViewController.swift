//
//  SignUpViewController.swift
//  2local
//
//  Created by Hasan Sedaghat on 10/10/20.
//  Copyright © 2020 2local Inc. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import KVNProgress
class SignUpViewController: BaseVC {

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var emailTXF: SkyFloatingLabelTextField! {
        didSet {
            emailTXF.titleFont = .TLFont(weight: .medium,
                                         size: 12)
            emailTXF.placeholderFont = .TLFont()
            emailTXF.font = .TLFont()
        }
    }
    @IBOutlet var passwordTXF: SkyFloatingLabelTextField! {
        didSet {
            passwordTXF.titleFont = .TLFont(weight: .medium,
                                            size: 12)
            passwordTXF.placeholderFont = .TLFont()
            passwordTXF.font = .TLFont()
        }
    }
    @IBOutlet weak var usernameTXF: SkyFloatingLabelTextField! {
        didSet {
            usernameTXF.titleFont = .TLFont(weight: .medium,
                                            size: 12)
            usernameTXF.placeholderFont = .TLFont()
            usernameTXF.font = .TLFont()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.setShadow(color: UIColor.color002CA4, opacity: 0.1, offset: CGSize(width: 0, height: -3), radius: 10)
        self.view.tapToDismissKeyboard()
        self.scrollView.handleKeyboard()
        // Do any additional setup after loading the view.
    }

    @IBAction func createAccount(_ sender: Any) {
        self.register()
    }

    func register() {
        if emailTXF.text != "" && passwordTXF.text != "" && usernameTXF.text != ""{
            DispatchQueue.main.async {
                KVNProgress.show()
            }
            APIManager.shared.signup(name: self.usernameTXF.text!, email: emailTXF.text!, password: passwordTXF.text!) { (data, response, _) in
                let result = APIManager.processResponse(response: response, data: data)
                if result.status {
                    DispatchQueue.main.async {
                        KVNProgress.showSuccess(withStatus: "You have successfully signed up! Please check out your email box for confirmation email.") {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        KVNProgress.showError(withStatus: "Sign up failed, seems like your username or email is already in use.")
                    }
                }
            }
        } else if usernameTXF.text == "" {
            DispatchQueue.main.async {
                KVNProgress.showError(withStatus: "The username field is required")
            }
        } else {
            DispatchQueue.main.async {
                KVNProgress.showError(withStatus: (self.emailTXF.text! == "") ? "The email field is required" : "The password field is required")
            }
        }
    }

    @IBAction func goToLogin(_ sender: Any) {
//        self.navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
}

//
//  LoginViewController.swift
//  2local
//
//  Created by Hasan Sedaghat on 12/30/19.
//  Copyright © 2019 2local Inc. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import KVNProgress
import LocalAuthentication


class LoginViewController: BaseVC, TwoVerificationDelegate {
    
    //MARK: - outlets
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet weak var fingerPrint: UIButton!
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
    
    @IBOutlet weak var showPasswordToggleButton: UIButton!
    
    //MARK: - properties
    var sp :String?
    var hidePassword = true
    let hidePasswordImage = UIImage(named: "eyeHide")?.tint(with: ._9796AE)
    let showPasswordImage = UIImage(named: "eyeFill")?.tint(with: ._9796AE)
    
    //MARK: - view cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    
    //MARK: - functions
    fileprivate func setupView() {
        self.view.setShadow(color: UIColor._002CA4, opacity: 0.1, offset: CGSize(width: 0, height: -3), radius: 10)
        self.view.tapToDismissKeyboard()
        
        self.scrollView.handleKeyboard()
        
        fingerPrint.isHidden = true
        
        passwordTXF.isSecureTextEntry = hidePassword
        
        showPasswordToggleButton.setImage(showPasswordImage, for: .normal)
        
    }
    
    @IBAction func fingerprint(_ sender: Any) {
        return
        /*
        let myContext = LAContext()
        let myReason = "For 2local Authntication"
        var authError: NSError?
        
        if myContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
            DispatchQueue.main.async {
                myContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: myReason) { (success, error) in
                    DispatchQueue.main.async {
                        if success {
                            if let userData = DataProvider.shared.keychain.getData("userData") {
                                do {
                                    let user = try JSONDecoder().decode(User.self, from: userData)
                                    DataProvider.shared.user = user
                                    self.emailTXF.text = DataProvider.shared.user?.email
                                    self.passwordTXF.text = DataProvider.shared.keychain.get("sp")
                                    
                                    self.login()
                                }
                                catch {
                                    DispatchQueue.main.async {
                                        KVNProgress.showError(withStatus: "Failed to login with fingerprint\nPlease login from email and password.", completion: {
                                        })
                                    }
                                }
                            }
                            else {
                                DispatchQueue.main.async {
                                    KVNProgress.showError(withStatus: "Failed to login with fingerprint\nPlease login from email and password.", completion: {
                                    })
                                }
                            }
                        }
                        else {
                            KVNProgress.showError(withStatus: "You didn't authenticate successfully")
                        }
                    }
                }
            }
        }
        else {
            DispatchQueue.main.async {
                KVNProgress.showError(withStatus: authError?.description)
            }
        }
        
        */
    }
    
    func login () {
        if emailTXF.text != "" && passwordTXF.text != "" {
            DispatchQueue.main.async {
                KVNProgress.show()
            }
            
            APIManager.shared.login(email: emailTXF.text!, password: passwordTXF.text!) { (data, response, error) in
                let result = APIManager.processResponse(response: response, data: data)
                if result.status {
                    do {
                        let resultData = try JSONDecoder().decode(ResultData<User>.self, from: data!)
                        if resultData.record != nil {
                            DataProvider.shared.user = resultData.record
                            LocalDataManager.shared.setUser(resultData.record)
                            LocalDataManager.shared.setToken(resultData.record?.apiToken ?? resultData.record?.accessToken ?? "")
                            
                            DispatchQueue.main.async {
                                self.sp = self.passwordTXF.text
                                DataProvider.shared.keychain.set(self.sp!, forKey: "sp")
                                let act = "\(DataProvider.shared.user?.tokenType ?? "-") \(DataProvider.shared.user?.accessToken ?? "+")"
                                DataProvider.shared.keychain.set(act, forKey: "act")
                            }
                            if let record = resultData.record, (record.twofaStatus ?? false) == true {
                                DispatchQueue.main.async {
                                    KVNProgress.dismiss {
                                        self.performSegue(withIdentifier: "goTo2FA", sender: nil)
                                    }
                                }
                            } else {
                                self.makeTrust(privateKey: "")
                            }
                        }
                        else {
                            DispatchQueue.main.async {
                                KVNProgress.showError(withStatus: resultData.message)
                            }
                        }
                    }
                    catch {
                        DispatchQueue.main.async {
                            KVNProgress.showError(withStatus: "Failed to parse login data")
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
        else {
            DispatchQueue.main.async {
                KVNProgress.showError(withStatus: (self.emailTXF.text! == "") ? "The email field is required" : "The password field is required")
            }
        }
    }
    
    func verificationStatus(_ status: Bool) {
        if status {
            KVNProgress.show()
            self.makeTrust(privateKey: "")
        }
    }
    
    func makeTrust(privateKey: String) {
        DispatchQueue.main.async {
            KVNProgress.dismiss {
                if let userData = try? JSONEncoder().encode(DataProvider.shared.user) {
                    DataProvider.shared.keychain.set(userData, forKey: "userData")
                }
                if let onBoardingVC = self.presentingViewController?.presentingViewController {
                    onBoardingVC.dismiss(animated: true, completion: {
                        onBoardingVC.viewDidAppear(false)
                    })
                }
                else {
                    let vc = UIStoryboard.splash.instantiate(viewController: SplashViewController.self)
                    self.present(vc, animated: false)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goTo2FA" {
            let destVC = segue.destination as! LoginTFAViewController
            destVC.delegate = self
        }
    }
    
    //MARK: - actions
    @IBAction func login(_ sender: Any) {
        self.login()
    }
    
    @IBAction func closeTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func showHidePasswordTapped(_ sender: Any) {
        hidePassword.toggle()
        passwordTXF.isSecureTextEntry = hidePassword
        
        if hidePassword {
            showPasswordToggleButton.setImage(showPasswordImage, for: .normal)
        } else {
            showPasswordToggleButton.setImage(hidePasswordImage, for: .normal)
        }
    }
}

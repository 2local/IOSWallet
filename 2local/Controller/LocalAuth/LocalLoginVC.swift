//
//  LocalLoginVC.swift
//  2local
//
//  Created by Ebrahim Hosseini on 9/20/21.
//  Copyright © 2021 2local Inc. All rights reserved.
//

import UIKit
import LocalAuthentication
import SkyFloatingLabelTextField
import KVNProgress

class LocalLoginVC: BaseVC {
    
    //MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var biometricTitleLabel: UILabel!
    @IBOutlet weak var resetWalletDescriptionLabel: UILabel!
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var biometricSwitch: UISwitch!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var restWalletButton: UIButton!
    @IBOutlet weak var biometricSectionStack: UIStackView!
    @IBOutlet weak var biometricButton: UIButton!
    
    
    //MARK: - Properties
    let context = LAContext()
    
    
    //MARK: - View cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: - Functions
    fileprivate func setupView() {
        titleLabel.font = .TLFont(weight: .bold, size: 25, style: .body)
        
        resetWalletDescriptionLabel.font = .TLFont(weight: .regular, size: 15, style: .body)
        
        biometricTitleLabel.font = .TLFont(weight: .regular, size: 14, style: .body)
        
        
        ([passwordTextField] as! [SkyFloatingLabelTextField]).forEach { (textField) in
            textField.isSecureTextEntry = true
            textField.font = .TLFont(weight: .regular, size: 14, style: .body)
            textField.placeholderFont = .TLFont(weight: .regular, size: 14, style: .body)
            textField.selectedTitleColor = ._EF8749
            textField.placeholder = "Password"
            
        }
        
        ([titleLabel, resetWalletDescriptionLabel, biometricTitleLabel] as! [UILabel]).forEach { (label) in
            label.textColor = ._707070
        }
        
        loginButton.backgroundColor = ._EF8749
        loginButton.setCornerRadius(8)
        loginButton.setTitleColor(.white, for: .normal)
        
        biometricSwitch.isOn = LocalDataManager.shared.isBiometricEnable
        
        if biometricSwitch.isOn {
            authenticate()
        }
        
        updateBiometricSection()
        
        updateSwitchBiometric()
    }
    
    fileprivate func updateBiometricSection() {
        let biometricType: BiometricType = context.biometricType
        biometricSectionStack.isHidden = false
        
        var icon: UIImage!
        
        switch biometricType {
            case .none:
                biometricSectionStack.isHidden = true
            case .faceID:
                biometricTitleLabel.text = "Sign in with Face ID?"
                if #available(iOS 13.0, *) {
                    icon = UIImage(systemName: "faceid")
                } else {
                    icon = UIImage(named: "faceid")?.tint(with: ._707070)
                }
            case.touchID:
                biometricTitleLabel.text = "Sign in with Touch ID?"
                if #available(iOS 13.0, *) {
                    icon = UIImage(systemName: "touchid")
                } else {
                    icon = UIImage(named: "touchid")?.tint(with: ._707070)
                }
        }
        
        biometricButton.setImage(icon, for: .normal)
    }
    
    func authenticate() {
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Please authenticate in order to use 2local"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [weak self] success, authenticationError in
                
                DispatchQueue.main.async {
                    if success {
                        self?.goToHome()
                    } else {
                        self?.passwordTextField.becomeFirstResponder()
                    }
                }
            }
        } else {
            let ac = UIAlertController(title: "Biometry unavailable", message: "Your device is not configured for biometric authentication.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(ac, animated: true)
        }
    }
    
    fileprivate func updateSwitchBiometric() {
        biometricButton.isHidden = true
        if biometricSwitch.isOn {
            biometricButton.isHidden = false
        }
    }
    
    fileprivate func goToHome() {
        let vc = TabbarVC()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    fileprivate func goToCreatePassword() {
        let vc = UIStoryboard.authentication.instantiate(viewController: CreatePasswordVC.self)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    
    //MARK: - Actions
    @IBAction func switchBiometricTapped(_ sender: UISwitch) {
        updateSwitchBiometric()
        LocalDataManager.shared.setBiometric(biometricSwitch.isOn)
    }
    
    @IBAction func biometricTapped(_ sender: UIButton) {
        authenticate()
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        let password = passwordTextField.text
        if LocalDataManager.shared.password == password {
            goToHome()
        } else {
            KVNProgress.showError(withStatus: "Your password is wrong, try again!")
        }
    }
    
    @IBAction func resetWalletTapped(_ sender: UIButton) {
        LocalDataManager.shared.password = nil
        LocalDataManager.shared.setBiometric(true)
        LocalDataManager.shared.setToken("")
        LocalDataManager.shared.setUser(nil)
        
        DataProvider.shared.wallets.removeAll()
        
        for coin in Coins.allCases {
            userDefaults.removeObject(forKey: coin.rawValue)
        }
        
        for userKey in UserDefaultsKey.allCases {
            userDefaults.removeObject(forKey: userKey.rawValue)
        }
        
        goToCreatePassword()
    }
}

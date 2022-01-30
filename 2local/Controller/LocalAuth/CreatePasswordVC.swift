//
//  CreatePasswordVC.swift
//  2local
//
//  Created by Ebrahim Hosseini on 9/20/21.
//  Copyright © 2021 2local Inc. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import LocalAuthentication
import KVNProgress

class CreatePasswordVC: BaseVC {

  // MARK: - Outlets
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var biometricTitleLabel: UILabel!
  @IBOutlet weak var acceptionTitleLabel: UILabel!
  @IBOutlet weak var passwordTextField: SkyFloatingLabelTextField!
  @IBOutlet weak var confirmPasswordTextField: SkyFloatingLabelTextField!
  @IBOutlet weak var biometricSwitch: UISwitch!
  @IBOutlet weak var acceptionButton: UIButton!
  @IBOutlet weak var createPasswordButton: UIButton!
  @IBOutlet weak var biometricSectionStack: UIStackView!

  // MARK: - Properties
  private var agreement: Bool = false

  let context = LAContext()

  // MARK: - View cycle
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

  // MARK: - Functions
  fileprivate func setupView() {
    titleLabel.font = .TLFont(weight: .bold, size: 18, style: .body)

    descriptionLabel.font = .TLFont(weight: .regular, size: 15, style: .body)

    biometricTitleLabel.font = .TLFont(weight: .regular, size: 14, style: .body)

    acceptionTitleLabel.font = .TLFont(weight: .regular, size: 14, style: .body)

    ([passwordTextField, confirmPasswordTextField]).forEach { (textField) in
      guard let textField = textField else { return }
      textField.isSecureTextEntry = true
      textField.font = .TLFont(weight: .regular, size: 14, style: .body)
      textField.placeholderFont = .TLFont(weight: .regular, size: 14, style: .body)
      textField.selectedTitleColor = .EF8749

      passwordTextField.placeholder = "Password"
      confirmPasswordTextField.placeholder = "Confirm Password"
    }

    ([titleLabel, descriptionLabel, biometricTitleLabel, acceptionTitleLabel]).forEach { (label) in
      guard let label = label else { return }
      label.textColor = .color707070
    }

    createPasswordButton.backgroundColor = .EF8749
    createPasswordButton.setCornerRadius(8)
    createPasswordButton.setTitleColor(.white, for: .normal)

    biometricSwitch.isOn = true
    updateAgreementStatus()
    updateBiometricSection()
  }

  fileprivate func updateAgreementStatus() {
    acceptionButton.setCornerRadius(4)
    if agreement {
      acceptionButton.setImage(UIImage(named: "checkFill"), for: .normal)
      acceptionTitleLabel.textColor = .color303030
      createPasswordButton.backgroundColor = .EF8749
      createPasswordButton.isEnabled = true
    } else {
      acceptionButton.setImage(UIImage(named: "checkEmpty"), for: .normal)
      acceptionTitleLabel.textColor = .color707070
      DispatchQueue.main.async {
        self.createPasswordButton.backgroundColor = UIColor.EF8749.withAlphaComponent(0.5)
      }
      createPasswordButton.isEnabled = false
    }
  }

  fileprivate func updateBiometricSection() {
    let biometricType: BiometricType = context.biometricType
    biometricSectionStack.isHidden = false

    switch biometricType {
      case .none:
        biometricSectionStack.isHidden = true
      case .faceID:
        biometricTitleLabel.text = "Sign in with Face ID?"
      case.touchID:
        biometricTitleLabel.text = "Sign in with Touch ID?"
    }

    LocalDataManager.shared.setBiometric(biometricSwitch.isOn)
  }

  fileprivate func goToHome() {
    let vc = TabbarVC()
    vc.modalPresentationStyle = .fullScreen
    present(vc, animated: true)
  }

  // MARK: - Actions
  @IBAction func switchBiometricTapped(_ sender: UISwitch) {
    LocalDataManager.shared.setBiometric(biometricSwitch.isOn)
  }

  @IBAction func checkTapped(_ sender: UIButton) {
    agreement.toggle()
    updateAgreementStatus()
  }

  @IBAction func createPasswordTapped(_ sender: UIButton) {
    let password = passwordTextField.text
    let confirmPassword = confirmPasswordTextField.text

    if password != confirmPassword {
      KVNProgress.showError(withStatus: "Password and confirm password is not matched!")
      return
    }

    LocalDataManager.shared.setPassword(password)
    goToHome()
  }

}

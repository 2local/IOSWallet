//
//  DeletionConfirmationViewController.swift
//  2local
//
//  Created by Ibrahim Hosseini on 2/9/22.
//  Copyright © 2022 2local Inc. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class DeletionConfirmationViewController: BaseVC {

  // MARK: - Outlets
  @IBOutlet weak var passwordLabel: UILabel!
  @IBOutlet weak var passwordTextField: SkyFloatingLabelTextField!

  @IBOutlet weak var twoFactorAuthPasswordLabel: UILabel!
  @IBOutlet weak var twoFactorAuthPasswordTextField: SkyFloatingLabelTextField!

  @IBOutlet weak var deleteAccountButton: UIButton!

  // MARK: - Properties

  // MARK: - View controller life cycle methods

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
    setNavigation(title: "Confirm your password",
                  largeTitle: true)

    deleteAccountButton.setTitle("Delete Account", for: .normal)
    deleteAccountButton.setTitleColor(.white, for: .normal)
    deleteAccountButton.backgroundColor = .FE6C6C
    deleteAccountButton.setCornerRadius(5)

    passwordLabel.text = "Complete your delete request by entering the password associated with your account."
    passwordLabel.textColor = .color919191
    passwordLabel.numberOfLines = 0
    passwordLabel.font = .TLFont(weight: .regular,
                                 size: 12,
                                 style: .body)

    twoFactorAuthPasswordLabel.text = "Complete your delete request by entering the two factor authentication " +
    "password associated with your account."
    twoFactorAuthPasswordLabel.textColor = .color919191
    twoFactorAuthPasswordLabel.numberOfLines = 0
    twoFactorAuthPasswordLabel.font = .TLFont(weight: .regular,
                                              size: 12,
                                              style: .body)

    ([passwordTextField,
      twoFactorAuthPasswordTextField]).forEach { (textField) in
      guard let textField = textField else { return }
      textField.isSecureTextEntry = true
      textField.font = .TLFont(weight: .regular, size: 14, style: .body)
      textField.placeholderFont = .TLFont(weight: .regular, size: 14, style: .body)
      textField.selectedTitleColor = .EF8749

      passwordTextField.placeholder = "Password"
      twoFactorAuthPasswordTextField.placeholder = "Two Factor Authentication Password"
    }
  }

  private func deleteAccount() {
    // TODO: CALL DELETE ACCOUNT API
  }

  private func showDeleteAccountAlert() {
    let title = ""
    let message = "Delete account?"
    let alertViewController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)

    let cancelAction = UIAlertAction(title: "Cancel",
                                     style: .cancel)

    let deleteAction = UIAlertAction(title: "Delete account",
                                     style: .destructive) { [weak self] _ in
      guard let self = self else { return }
      self.deleteAccount()
    }

    alertViewController.addAction(cancelAction)
    alertViewController.addAction(deleteAction)

    present(alertViewController, animated: true)
  }

  // MARK: - Actions

  @IBAction func deleteAccountTapped(_ sender: UIButton) {
    showDeleteAccountAlert()
  }

}

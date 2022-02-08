//
//  DeletionViewController.swift
//  2local
//
//  Created by Ibrahim Hosseini on 2/8/22.
//  Copyright © 2022 2local Inc. All rights reserved.
//

import UIKit

class DeletionViewController: BaseVC {

  // MARK: - Outlets

  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var cancelButton: UIButton!
  @IBOutlet weak var deleteAccountButton: UIButton!
  @IBOutlet weak var imageView: UIImageView!

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
    let user = DataProvider.shared.user?.name ?? "your account"
    titleLabel.text = "This will delete \(user)"
    titleLabel.textColor = .color707070
    titleLabel.font = .TLFont(weight: .bold,
                              size: 20,
                              style: .body)

    descriptionLabel.text = "After delete account"
    descriptionLabel.textColor = .color919191
    descriptionLabel.numberOfLines = 0
    descriptionLabel.font = .TLFont(weight: .regular,
                                    size: 14,
                                    style: .body)

    cancelButton.setTitle("Cancel", for: .normal)
    cancelButton.backgroundColor = .color575757
    cancelButton.setTitleColor(.white, for: .normal)
    cancelButton.setCornerRadius(5)

    deleteAccountButton.setTitle("Delete Account", for: .normal)
    deleteAccountButton.setTitleColor(.white, for: .normal)
    deleteAccountButton.backgroundColor = .FE6C6C
    deleteAccountButton.setCornerRadius(5)

    imageView.image = UIImage(named: "")
    imageView.contentMode = .scaleAspectFill
    imageView.isHidden = true
  }

  private func deleteAccount() {
    // TODO: CALL DELETE ACCOUNT API
  }

  private func showDeleteAccountAlert() {
    let title = "Password"
    let message = "Enter password to delete account"
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

  @IBAction func cancelTapped(_ sender: UIButton) {
    if let navigation = navigationController {
      navigation.popViewController(animated: true)
    }
  }
}

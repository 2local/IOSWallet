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

    deleteAccountButton.setTitle("Delete Account", for: .normal)
    deleteAccountButton.setTitleColor(.white, for: .normal)
    deleteAccountButton.backgroundColor = .FE6C6C
    deleteAccountButton.setCornerRadius(5)

    setNavigation(title: "Delete your account",
                  largeTitle: true)
  }

  // MARK: - Actions

  @IBAction func deleteAccountTapped(_ sender: UIButton) {
    let viewController = UIStoryboard.settings.instantiate(viewController: DeletionConfirmationViewController.self)
    if let navigation = navigationController {
      navigation.pushViewController(viewController, animated: true)
    }
  }
}

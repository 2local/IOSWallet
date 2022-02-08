//
//  SettingsViewController.swift
//  2local
// ting//  Created by Hasan Sedaghat on 1/7/20.
//  Copyright © 2020 2local Inc. All rights reserved.
//

import UIKit
import KVNProgress

class SettingsViewController: BaseVC {

  // MARK: - outlets
  @IBAction func unwindToSettings(segue: UIStoryboardSegue) { }
  @IBOutlet var tableView: UITableView! {
    didSet {
      tableView.delegate = self
      tableView.dataSource = self
    }
  }

  // MARK: - properties
  let sectionTitles = ["Account",
                       "Security",
                       "More",
                       "Account Deletion"]
  let firstSectionTitles = ["Account Info",
                            "Address Book",
                            "Currency",
                            "Affiliate",
                            "Add Marketplace"]
  let secondSectionTitles = ["2-Factor Authentication",
                             "Password"]
  let thirdSectionTitles = DataProvider.shared.user != nil ? ["Help & Support",
                                                              "About 2local",
                                                              "Log out"] : ["Help & Support",
                                                                            "About 2local"]
  let forthSectionTitles = DataProvider.shared.user != nil ? ["Delete Account"] : []

  let firstSectionIcons = [#imageLiteral(resourceName: "male-user-shadow"), #imageLiteral(resourceName: "Layer 2-2"), #imageLiteral(resourceName: "coin"), #imageLiteral(resourceName: "Layer -3"), #imageLiteral(resourceName: "marketplaceIcon")]
  let secondSectionIcons = [#imageLiteral(resourceName: "qr-code"), #imageLiteral(resourceName: "pin-code")]
  let thirdSectionIcons = [#imageLiteral(resourceName: "help-web-button"), #imageLiteral(resourceName: "icon"), #imageLiteral(resourceName: "sign-out-option")]
  let forthSectionIcons = [#imageLiteral(resourceName: "delete")]

  // MARK: - life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    createCloseButton()
  }

  override func viewDidAppear(_ animated: Bool) {
    tableView.reloadData()
  }

  // MARK: - functions
  fileprivate func createCloseButton() {
    let closeButton = createButtonItems("close", action: #selector(close))
    self.navigationItem.rightBarButtonItem = closeButton
  }

  @objc fileprivate func close() {
    dismiss(animated: true)
  }

  fileprivate func showLogoutAlert() {
    let title = ""
    let user = DataProvider.shared.user?.name ?? "your account"
    let message = "Log out of \(user)?"
    let alert = UIAlertController(title: title,
                                  message: message,
                                  preferredStyle: .alert)

    let cancelAction = UIAlertAction(title: "Cancel",
                                     style: .cancel)
    let logoutAction = UIAlertAction(title: "Log out",
                                     style: .default) { [weak self] _ in
      guard let self = self else { return }
      self.logout()
    }
    alert.addAction(cancelAction)
    alert.addAction(logoutAction)
    present(alert, animated: true)
  }

  fileprivate func logout() {

    LocalDataManager.shared.password = nil
    LocalDataManager.shared.setBiometric(true)
    LocalDataManager.shared.setToken("")
    LocalDataManager.shared.setUser(nil)

    DataProvider.shared.wallets.removeAll()

    for userKey in UserDefaultsKey.allCases {
      userDefaults.removeObject(forKey: userKey.rawValue)
    }

    for coin in Coins.allCases {
      userDefaults.removeObject(forKey: coin.rawValue)
    }

    if let userData = DataProvider.shared.keychain.getData("userData") {
      do {
        let user = try? JSONDecoder().decode(User.self, from: userData)
        user?.id = nil
        let userData = try? JSONEncoder().encode(user)
        DataProvider.shared.keychain.set(userData!, forKey: "userData")
      }
    }

    NotificationCenter.default.post(name: .walletRemove, object: nil)

    showLoginView(self)
  }
}

// MARK: - table view
extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {

  func numberOfSections(in tableView: UITableView) -> Int {
    sectionTitles.count
  }

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    if let headerView = Bundle.main.loadNibNamed("SettingsSectionHeader",
                                                 owner: self,
                                                 options: nil)?.first as? SettingsSectionHeaderView {
      headerView.titleLabel.text = sectionTitles[section]
      return headerView
    }
    return nil
  }

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    60
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0: return firstSectionTitles.count
    case 1: return secondSectionTitles.count
    case 2: return thirdSectionTitles.count
    case 3: return forthSectionTitles.count
    default: return 0
    }
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    58
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? SettingsTableViewCell
    else { return UITableViewCell() }

    cell.selectionStyle = .none

    let row = indexPath.row

    if row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
      cell.footerView.alpha = 0
    } else {
      cell.footerView.alpha = 1
    }

    switch indexPath.section {
    case 0: return cellForRowAtAccountSection(at: row, cell: cell)
    case 1: return cellForRowAtSecuritySection(at: row, cell: cell)
    case 2: return cellForRowAtMoreSection(at: row, cell: cell)
    case 3: return cellForRowAtDeletionSection(at: row, cell: cell)
    default: return cell
    }
  }

  /// Implement cell for row at index
  func cellForRowAtAccountSection(at row: Int, cell: SettingsTableViewCell) -> SettingsTableViewCell {
    cell.titleLabel.text = firstSectionTitles[row]
    cell.iconIMG.image = firstSectionIcons[row]
    if row == 2 {
      cell.descLabel.alpha = 1
      cell.descLabel.text = "USD" // DataProvider.shared.defaultEx
      cell.descLabel.textColor = .white
    } else {
      cell.descLabel.alpha = 0
    }
    return cell
  }

  func cellForRowAtSecuritySection(at row: Int, cell: SettingsTableViewCell) -> SettingsTableViewCell {
    cell.titleLabel.text = secondSectionTitles[row]
    cell.iconIMG.image = secondSectionIcons[row]
    if row == 0 {
      cell.descLabel.alpha = 1
      cell.descLabel.text = "OFF"
      cell.descLabel.textColor = .white
      if let user = DataProvider.shared.user, (user.twofaStatus ?? false == false) {
        cell.descLabel.text = "OFF"
      } else if let user = DataProvider.shared.user, (user.twofaStatus ?? false == true) {
        cell.descLabel.text = "ON"
      } else {
        cell.descLabel.text = "ON"
      }

    } else {
      cell.descLabel.alpha = 0
    }
    return cell
  }

  func cellForRowAtMoreSection(at row: Int, cell: SettingsTableViewCell) -> SettingsTableViewCell {
    cell.titleLabel.text = thirdSectionTitles[row]
    cell.iconIMG.image = thirdSectionIcons[row]
    cell.descLabel.alpha = 0
    return cell
  }

  func cellForRowAtDeletionSection(at row: Int, cell: SettingsTableViewCell) -> SettingsTableViewCell {
    cell.titleLabel.text = forthSectionTitles[row]
    cell.iconIMG.image = forthSectionIcons[row].tint(with: .solitude)
    cell.descLabel.alpha = 0
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let row = indexPath.row
    switch indexPath.section {
    case 0: didSelectAccountSection(at: row)
    case 1: didSelectSecuritySection(at: row)
    case 2: didSelectMoreSection(at: row)
    case 3: didSelectDeletionSection(at: row)
    default: break
    }
  }

  /// implementation did select row at index functions
  fileprivate func didSelectAccountSection(at row: Int) {
    var viewController: UIViewController!
    switch row {
    case 0:
      if DataProvider.shared.user != nil {
        viewController = UIStoryboard.settings.instantiate(viewController: AccountInfoViewController.self)
      } else {
        showLoginView(self)
      }
    case 1:
      if DataProvider.shared.user != nil {
        viewController = UIStoryboard.settings.instantiate(viewController: AddressBookViewController.self)
      } else {
        showLoginView(self)
      }
    case 2:
      return
      // viewController = UIStoryboard.settings.instantiate(viewController: CurrencyViewController.self)
    case 3:
      if DataProvider.shared.user != nil {
        viewController = UIStoryboard.settings.instantiate(viewController: AffiliateViewController.self)
      } else {
        showLoginView(self)
      }
    case 4:
      if DataProvider.shared.user != nil {
        viewController = UIStoryboard.settings.instantiate(viewController: AddMarketplaceVC.self)
      } else {
        showLoginView(self)
      }
    default: break
    }
    if let navigation = navigationController, let viewController = viewController {
      navigation.pushViewController(viewController, animated: true)
    }
  }

  fileprivate func didSelectSecuritySection(at row: Int) {
    if secondSectionTitles[row] == "2-Factor Authentication" {
      KVNProgress.showError(withStatus: "You can only change the 2-Factor Authentication status from the website")
    } else {
      KVNProgress.showError(withStatus: "Password setting is temporarily unavailable")
//      if DataProvider.shared.user != nil {
//        viewController = UIStoryboard.settings.instantiate(viewController: ChangePasswordViewController.self)
//        if let navigation = navigationController {
//          navigation.pushViewController(vc, animated: true)
//        }
//      } else {
//        showLoginView(self)
//      }
    }
  }

  fileprivate func didSelectMoreSection(at row: Int) {
    var viewController: UIViewController!
    switch row {
    case 0: break// viewController = UIStoryboard.settings.instantiate(viewController: .self)
    case 1:
      viewController = UIStoryboard.settings.instantiate(viewController: AboutViewController.self)
      if let navigation = navigationController {
        navigation.pushViewController(viewController, animated: true)
      }
    default: showLogoutAlert()
    }
  }

  fileprivate func didSelectDeletionSection(at row: Int) {
    switch row {
    case 0:
      let viewController = UIStoryboard.settings.instantiate(viewController: DeletionViewController.self)
      if let navigation = navigationController {
        navigation.pushViewController(viewController, animated: true)
      }
    default: break
    }
  }

}

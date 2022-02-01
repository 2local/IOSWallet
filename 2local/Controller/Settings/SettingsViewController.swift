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
  let sectionTitles = ["", "Security", "More"]
  let firstSectionTitles = ["Account Info", "Address Book", "Currency", "Affiliate", "Add Marketplace"]
  let secondSectionTitles = ["2-Factor Authentication", "Password"]
  let thirdSectionTitles = DataProvider.shared.user != nil ? ["Help & Support", "About 2local", "Sign out"] : ["Help & Support", "About 2local"]
  let firstSectionIcons = [#imageLiteral(resourceName: "male-user-shadow"), #imageLiteral(resourceName: "Layer 2-2"), #imageLiteral(resourceName: "coin"), #imageLiteral(resourceName: "Layer -3"), #imageLiteral(resourceName: "marketplaceIcon")]
  let secondSectionIcons = [#imageLiteral(resourceName: "qr-code"), #imageLiteral(resourceName: "pin-code")]
  let thirdSectionIcons = [#imageLiteral(resourceName: "help-web-button"), #imageLiteral(resourceName: "icon"), #imageLiteral(resourceName: "sign-out-option")]

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
    let closeButtton = createButtonItems("close", action: #selector(close))
    self.navigationItem.rightBarButtonItem = closeButtton
  }

  @objc fileprivate func close() {
    dismiss(animated: true)
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
    return sectionTitles.count
  }

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

    if let headerView = Bundle.main.loadNibNamed("SettingsSectionHeader", owner: self, options: nil)?.first as? SettingsSectionHeaderView {
      headerView.titleLabel.text = sectionTitles[section]
      return headerView
    }
    return nil
  }

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    if section == 0 {
      return 0
    }
    return 60
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
      case 0:
        return firstSectionTitles.count
      case 1:
        return secondSectionTitles.count
      case 2:
        return thirdSectionTitles.count
      default:
        return 0
    }
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 58
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? SettingsTableViewCell else { return UITableViewCell() }
    cell.selectionStyle = .none
    switch indexPath.section {
      case 0:
        cell.titleLabel.text = firstSectionTitles[indexPath.row]
        cell.iconIMG.image = firstSectionIcons[indexPath.row]
        if indexPath.row == 2 {
          cell.descLabel.alpha = 1
          cell.descLabel.text = "USD"// DataProvider.shared.defaultEx
          cell.descLabel.textColor = .white
        } else {
          cell.descLabel.alpha = 0
        }
      case 1:
        cell.titleLabel.text = secondSectionTitles[indexPath.row]
        cell.iconIMG.image = secondSectionIcons[indexPath.row]
        if indexPath.row == 0 {
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
          //                    cell.titleLabel.textColor = ._solitude
        }
      case 2:
        cell.titleLabel.text = thirdSectionTitles[indexPath.row]
        cell.iconIMG.image = thirdSectionIcons[indexPath.row]
        cell.descLabel.alpha = 0
      default:
        return cell
    }
    if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
      cell.footerView.alpha = 0
    } else {
      cell.footerView.alpha = 1
    }

    return cell

  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    var vc: UIViewController!
    switch indexPath.section {
      case 0:
        switch indexPath.row {
          case 0:
            if DataProvider.shared.user != nil {
              vc = UIStoryboard.settings.instantiate(viewController: AccountInfoViewController.self)
            } else {
              showLoginView(self)
            }
          case 1:
            if DataProvider.shared.user != nil {
              vc = UIStoryboard.settings.instantiate(viewController: AddressBookViewController.self)
            } else {
              showLoginView(self)
            }
          case 2:
            return
            //                        vc = UIStoryboard.settings.instantiate(viewController: CurrencyViewController.self)
          case 3:
            if DataProvider.shared.user != nil {
              vc = UIStoryboard.settings.instantiate(viewController: AffiliateViewController.self)
            } else {
              showLoginView(self)
            }
          case 4:
            if DataProvider.shared.user != nil {
              vc = UIStoryboard.settings.instantiate(viewController: AddMarketplaceVC.self)
            } else {
              showLoginView(self)
            }
          default:
            break
        }

        if let navigation = navigationController, let vc = vc {
          navigation.pushViewController(vc, animated: true)
        }
      case 1:
        if secondSectionTitles[indexPath.row] == "2-Factor Authentication" {
          KVNProgress.showError(withStatus: "You can only change the 2-Factor Authentication status from the website")
          break
        } else {
          KVNProgress.showError(withStatus: "Password setting is temporarily unavailable")
          break
          //                    if DataProvider.shared.user != nil {
          //                        vc = UIStoryboard.settings.instantiate(viewController: ChangePasswordViewController.self)
          //                        if let navigation = navigationController {
          //                            navigation.pushViewController(vc, animated: true)
          //                        }
          //                    } else {
          //                        showLoginView(self)
          //                    }
        }
      case 2:
        switch indexPath.row {
          case 0:
            break// vc = UIStoryboard.settings.instantiate(viewController: .self)
          case 1:
            vc = UIStoryboard.settings.instantiate(viewController: AboutViewController.self)
            if let navigation = navigationController {
              navigation.pushViewController(vc, animated: true)
            }
          default:
            logout()
            break
        }
      default:
        break
    }
  }

}

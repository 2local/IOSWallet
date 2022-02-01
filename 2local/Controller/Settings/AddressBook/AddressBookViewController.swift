//
//  AddressBookViewController.swift
//  2local
//
//  Created by Hasan Sedaghat on 1/8/20.
//  Copyright © 2020 2local Inc. All rights reserved.
//

import UIKit

class AddressBookViewController: BaseVC, UITableViewDelegate, UITableViewDataSource {

  @IBOutlet var tableView: UITableView! {
    didSet {
      tableView.delegate = self
      tableView.dataSource = self
      tableView.contentInset = UIEdgeInsets(top: 25, left: 0, bottom: 0, right: 0)
    }
  }

  var contacts = [Contact]()

  override func viewDidAppear(_ animated: Bool) {
    if let contactsData = UserDefaults.standard.object(forKey: "contacts") {
      let contactsItems = try? PropertyListDecoder().decode([Contact].self, from: (contactsData as? Data)!)
      self.contacts = contactsItems!
    } else {
      let encodedData = try? PropertyListEncoder().encode(contacts)
      UserDefaults.standard.set(encodedData, forKey: "contacts")
      UserDefaults.standard.synchronize()
    }
    tableView.reloadSections(IndexSet.init(integer: 0), with: .automatic)
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0 {
      return contacts.count == 0 ? 1 : contacts.count
    } else {
      return 1
    }
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.section == 0 {
      return contacts.count == 0 ? 200 : 95
    } else {
      return 96
    }
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.section == 0 {
      if contacts.count == 0 {
        let noContactCell = tableView.dequeueReusableCell(withIdentifier: "noContactCell")
        noContactCell?.selectionStyle = .none
        return noContactCell ?? UITableViewCell()
      } else {
        guard let contactCell = tableView.dequeueReusableCell(withIdentifier: "contactCell") as? AddressBookTableViewCell else { return UITableViewCell() }
        contactCell.nameLabel.text = contacts[indexPath.row].name
        contactCell.walletNumberLabel.text = contacts[indexPath.row].walletNumber
        contactCell.selectionStyle = .none
        contactCell.removeBTN.tag = indexPath.row
        contactCell.removeBTN.addTarget(self, action: #selector(removeContact(sender:)), for: .touchUpInside)
        return contactCell
      }
    } else {
      guard let footerCell = tableView.dequeueReusableCell(withIdentifier: "footerCell") as? AddressBookFooterTableViewCell else { return UITableViewCell() }
      footerCell.addContactBTN.addTarget(self, action: #selector(goToAddContact), for: .touchUpInside)
      footerCell.selectionStyle = .none
      return footerCell
    }
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if contacts.count != 0 {
      //            performSegue(withIdentifier: "goToContactDetail", sender: indexPath.row)
      let vc = UIStoryboard.settings.instantiate(viewController: ContactDetailViewController.self)
      if let navigation = navigationController {
        navigation.pushViewController(vc, animated: true)
      }
    }
  }

  @objc func removeContact(sender: UIButton) {
    self.contacts.remove(at: sender.tag)
    let encodedData = try? PropertyListEncoder().encode(contacts)
    UserDefaults.standard.set(encodedData, forKey: "contacts")
    tableView.reloadSections(IndexSet.init(integer: 0), with: .automatic)
  }

  @objc func goToAddContact() {
    let vc = UIStoryboard.settings.instantiate(viewController: AddContactViewController.self)
    if let navigation = navigationController {
      navigation.pushViewController(vc, animated: true)
    }
    //        self.performSegue(withIdentifier: "goToAddContact", sender: nil)
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "goToContactDetail" {
      if let destVC = segue.destination as? ContactDetailViewController {
        destVC.contact = self.contacts[(sender as? Int) ?? 0]
        destVC.index = sender as? Int
      }
    }
  }
}

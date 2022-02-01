//
//  AddContactViewController.swift
//  2local
//
//  Created by Hasan Sedaghat on 1/9/20.
//  Copyright © 2020 2local Inc. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import KVNProgress

class AddContactViewController: BaseVC, ScanWalletNumberDelegate {

  @IBOutlet var nameTXF: SkyFloatingLabelTextField! {
    didSet {
      nameTXF.titleFont = .TLFont(weight: .medium,
                                  size: 12)
      nameTXF.placeholderFont = .TLFont()
      nameTXF.font = .TLFont()
    }
  }
  @IBOutlet var walletNumberTXF: SkyFloatingLabelTextField! {
    didSet {
      walletNumberTXF.titleFont = .TLFont(weight: .medium,
                                          size: 12)
      walletNumberTXF.placeholderFont = .TLFont()
      walletNumberTXF.font = .TLFont()
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.tapToDismissKeyboard()
  }

  @IBAction func saveContact(_ sender: Any) {
    if nameTXF.text! != "" && walletNumberTXF.text! != "" {
      if let contactsData = UserDefaults.standard.object(forKey: "contacts") {
        let contactsItems = try? PropertyListDecoder().decode([Contact].self, from: (contactsData as? Data)!)
        var contacts = contactsItems
        let contact = Contact()
        contact.name = nameTXF.text!
        contact.walletNumber = walletNumberTXF.text!
        contacts!.append(contact)
        let encodedData = try? PropertyListEncoder().encode(contacts)
        UserDefaults.standard.set(encodedData, forKey: "contacts")

        KVNProgress.showSuccess(withStatus: "Contact saved successfully") {
          self.navigationController?.popViewController(animated: true)
        }
      } else {
        KVNProgress.showError(withStatus: "Cannot save the contact!\nPlease contact us")
      }
    } else {
      if nameTXF.text == "" {
        KVNProgress.showError(withStatus: "Please fill name field")
      } else {
        KVNProgress.showError(withStatus: "Please fill wallet address field")
      }
    }
  }

  @IBAction func scanQR(_ sender: Any) {
    self.performSegue(withIdentifier: "goToScan", sender: nil)
  }

  func walletDidScan(str: String?) {
    walletNumberTXF.text = str
  }
  @IBAction func pasteAction(_ sender: Any) {
    walletNumberTXF.text = UIPasteboard.general.string
  }
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "goToScan" {
      if let navVC = segue.destination as? UINavigationController {
        if let destVC = navVC.children.first as? ScanWalletViewController {
          destVC.delegate = self
        }
      }
    }
  }
}

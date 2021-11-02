//
//  ContactDetailViewController.swift
//  2local
//
//  Created by Hasan Sedaghat on 1/9/20.
//  Copyright © 2020 2local Inc. All rights reserved.
//

import UIKit
import KVNProgress
class ContactDetailViewController: BaseVC {
    
    @IBOutlet var nameLabel: UILabel! {
        didSet {
            nameLabel.text = contact?.name
        }
    }
    @IBOutlet var walletNumberLabel: UILabel!{
        didSet {
            walletNumberLabel.text = contact?.walletNumber
        }
    }
    
    var contact : Contact?
    var index:Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func send(_ sender: Any) {
        self.performSegue(withIdentifier: "goToSend", sender: nil)
    }
    
    @IBAction func remove(_ sender: Any) {
        if index != nil {
            if let contactsData = UserDefaults.standard.object(forKey: "contacts") {
                let contactsItems = try? PropertyListDecoder().decode([Contact].self, from: contactsData as! Data)
                var contacts = contactsItems
                contacts!.remove(at: index!)
                let encodedData = try? PropertyListEncoder().encode(contacts)
                UserDefaults.standard.set(encodedData, forKey: "contacts")
                KVNProgress.showSuccess(withStatus: "Contact removed successfully") {
                    self.navigationController?.popViewController(animated: true)
                }
            }
            else {
                KVNProgress.showError(withStatus: "Cannot remove the contact!\nPlease contact us")
            }
        }
        else {
            KVNProgress.showError(withStatus: "Cannot remove the contact!\nPlease contact us")
        }
    }
    
    @IBAction func copyAction(_ sender: Any) {
        UIPasteboard.general.string = contact?.walletNumber
        KVNProgress.showSuccess(withStatus: "Wallet number copied to clipboard")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToSend" {
            let destVC = segue.destination as! SendViewController
            destVC.walletNumber = contact?.walletNumber ?? ""
        }
    }
}

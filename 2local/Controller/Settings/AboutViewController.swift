//
//  AboutViewController.swift
//  2local
//
//  Created by Hasan Sedaghat on 1/9/20.
//  Copyright © 2020 2local Inc. All rights reserved.
//

import UIKit

class AboutViewController: SettingsViewController {
    
    let titles = ["Version","Privacy policy","Term of use","Give us feedback"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.rightBarButtonItems = nil
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SettingsTableViewCell
        cell.titleLabel.text = titles[indexPath.row]
        
        if indexPath.row == 0 {
            cell.descLabel.text = "v" + (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String)!
            cell.descLabel.alpha = 1
        }
        else {
            cell.descLabel.alpha = 0
        }
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            cell.footerView.alpha = 0
        }
        else {
            cell.footerView.alpha = 1
        }
        cell.selectionStyle = .none
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1  {
            self.performSegue(withIdentifier: "Privacy policy", sender: nil)
        }
        else if indexPath.row == 2 {
            self.performSegue(withIdentifier: "Term of use", sender: nil)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Do any additional setup after loading the view.
        
        let destVC = segue.destination as! WebViewViewController
        if segue.identifier == "Privacy policy" {
            destVC.url = "USER_AGREEMENT.pdf"//"https://2local.io/docs/privacy_policy.pdf"
        }
        else {
            destVC.url = "USER_AGREEMENT.pdf"//"https://2local.io/docs/terms_and_conditions.pdf"
        }
    }
}

//
//  CurrencyViewController.swift
//  2local
//
//  Created by Hasan Sedaghat on 1/8/20.
//  Copyright © 2020 2local Inc. All rights reserved.
//

import UIKit
import KVNProgress
class CurrencyViewController: BaseVC, UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 58
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SettingsTableViewCell
        cell.selectionStyle = .none
        switch indexPath.row {
        case 0:
            cell.titleLabel.text = "US Dollar"
            cell.descLabel.text = "USD"
        case 1:
            cell.titleLabel.text = "Euro"
            cell.descLabel.text = "EUR"
        default:
            return cell
        }
        
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            cell.footerView.alpha = 0
        }
        else {
            cell.footerView.alpha = 1
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            UserDefaults.standard.set("USD", forKey: "defEX")
            UserDefaults.standard.synchronize()
            DataProvider.shared.defaultEx = "USD"
            DataProvider.shared.exchangeRate?.defaultExR = DataProvider.shared.exchangeRate?.usd
            DataProvider.shared.exchangeRate?.ethereum?.defaultExchangeRate = DataProvider.shared.exchangeRate?.ethereum?.usd
            DataProvider.shared.exchangeRate?.defaultSym = "$"
            KVNProgress.showSuccess(withStatus: "Your currency changed to US Dollar") {
                self.navigationController?.popViewController(animated: true)
            }
        case 1:
            UserDefaults.standard.set("EUR", forKey: "defEX")
            UserDefaults.standard.synchronize()
            DataProvider.shared.defaultEx = "EUR"
            DataProvider.shared.exchangeRate?.defaultExR = DataProvider.shared.exchangeRate?.eur
            DataProvider.shared.exchangeRate?.ethereum?.defaultExchangeRate = DataProvider.shared.exchangeRate?.ethereum?.eur
            DataProvider.shared.exchangeRate?.defaultSym = "€"
            KVNProgress.showSuccess(withStatus: "Your currency changed to Euro") {
                self.navigationController?.popViewController(animated: true)
            }
        default:
            break
        }
    }
}

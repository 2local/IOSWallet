//
//  DashboardVC.swift
//  2local
//
//  Created by Ibrahim Hosseini on 10/10/21.
//  Copyright © 2021 2local Inc. All rights reserved.
//

import UIKit
import KVNProgress

class DashboardVC: BaseVC {
    
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var transactionButton: UIButton!
    
    //MARK: - Properties
    let months = Date().getLast12Month.0
    var transfers = [Transfer]()
    var transactionsChart = [TransactionChartModel]()
    var transactions = [TransactionHistoryModel]()
    var maxIncome : Float?
    var maxExpense : Float?
    var invisible = false
    
    var wallets: [Wallets] = []
    var walletBalance: String = "0"
    var defaultSym: String = ""
    var totalfiatWithSymbol: String = "$0"
    var ethTransactionHistory: [TransactionHistoryModel] = []
    
    //MARK: - View cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTable()
        setupNotifications()
        KVNProgress.show(withStatus: "", on: self.view)
        generateWalets()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        generateWalets()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - Functions
    fileprivate func setupView() {
        if UserDefaults.standard.bool(forKey: "invisible") {
            self.invisible = true
        } else {
            self.invisible = false
        }
        tableView.reloadData()
        setNavigation(title: "Total Balance", largTitle: true)
        
        settingsBarButtonItem()
    }
    
    func setupNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(generateWalets),
                                               name: Notification.Name.wallet,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(generateWalets),
                                               name: Notification.Name.walletRemove,
                                               object: nil)
    }

    func showTransfer(_ transfers: [Transfer]) {
        let months = Date().getLast12Month.1
        
        for month in months {
            let transaction = TransactionChartModel()
            transaction.date = month.prefix(7).description
            transactionsChart.append(transaction)
        }
        
        for month in transactionsChart {
            for transfer in transfers {
                if month.date == transfer.date?.prefix(7).description {
                    if transfer.source == "out" || transfer.from == transfer.wallet {
                        month.expenses +=  Float(transfer.quantity ?? "0.0")!
                    } else if transfer.source == "in" || transfer.to == transfer.wallet {
                        month.income +=  Float(transfer.quantity ?? "0.0")!
                    }
                }
            }
        }
        
        maxIncome = transactionsChart.map({$0.income}).max()
        maxExpense = transactionsChart.map({$0.expenses}).max()
    }
    
    fileprivate func refresfView() {
        walletQueue.async {
            self.getTotalFiat(self.wallets) { totalFiat in
                self.totalfiatWithSymbol = self.defaultSym + "\(totalFiat)".convertToPriceType()
                
                DispatchQueue.main.async {
                    self.tableView.reloadRows(at: self.indexPath(at: 0), with: .automatic)
                }
            }
            
            self.getTransactions(self.wallets) { transfers in
                self.transfers = transfers
                
                DispatchQueue.main.async {
                    self.tableView.reloadRows(at: self.indexPath(at: 2), with: .automatic)
                }
            }
            DispatchQueue.main.async {
                KVNProgress.dismiss()
            }
        }
    }
    
    @objc func generateWalets() {
        wallets.removeAll()
        wallets = DataProvider.shared.wallets
        defaultSym = DataProvider.shared.exchangeRate?.defaultSym ?? "$"
        tableView.reloadData()
        refresfView()
    }
    
    func indexPath(at row: Int) -> [IndexPath] {
        return [IndexPath(row: row, section: 0)]
    }
    
    fileprivate func settingsBarButtonItem() {
        let settingButtonItem = createButtonItems("settings", colorIcon: ._707070, action: #selector(goToSettings))
        navigationItem.rightBarButtonItem = settingButtonItem
    }
    
    fileprivate func notificationBarButtonItem() {
        let settingButtonItem = createButtonItems("notification", colorIcon: ._707070, action: #selector(goToNotification))
        navigationItem.leftBarButtonItem = settingButtonItem
    }
    
    @objc fileprivate func goToSettings() {
        let vc = UIStoryboard.settings.instantiate(viewController: SettingsViewController.self)
        let navc = TLNavigationController(rootViewController: vc)
        present(navc, animated: true)
    }
    
    @objc fileprivate func goToNotification() {
        let vc = UIStoryboard.notification.instantiate(viewController: NotificationViewController.self)
        let navc = TLNavigationController(rootViewController: vc)
        present(navc, animated: true)
    }
    
    //MARK: - actions
    @IBAction func goToTransaction(_ sender: Any) {
        let vc = UIStoryboard.home.instantiate(viewController: TransactionsViewController.self)
        vc.initWith(self.transfers)
        if let navigation = navigationController {
            navigation.pushViewController(vc, animated: true)
        }
    }
    
    
}

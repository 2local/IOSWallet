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
  var totalTokenWithSymbol: String = "0 2LC"
  var ethTransactionHistory: [TransactionHistoryModel] = []
  var userData: User?
  
  var showInfo = false
  var infoText = ""
  let config = FBRemoteConfig.shared
  
  enum SectionNames: CaseIterable {
    case info, balance, wallets, chart
  }
  
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
  
  func updateCloudData() {
    
    /// announcement message
    let announcementMessage = config.string(forKey: .announcementMessage)
    let showAnnouncementMessage = config.bool(forKey: .showAnnouncement)
    
    /// maintenance mode status
    let maintenanceModeMessage = config.string(forKey: .maintenanceMessage)
    let maintenanceMode = config.bool(forKey: .maintenanceMode)
    
    if maintenanceMode {
      showInfo = true
      infoText = maintenanceModeMessage
    } else if showAnnouncementMessage {
      showInfo = true
      infoText = announcementMessage
    }
    tableView.reloadData()
  }
  
  func checkEnableInstruction() {
    /// Instruction status and message
    let enableInstruction = config.bool(forKey: .enableInstructionWhenNoWalletAddedAndBalanceIsZero)
    let enableInstructionMessage = config.string(forKey: .enableInstructionWhenNoWalletAddedAndBalanceIsZeroMessage)
    
    if wallets.isEmpty, walletBalance == "0", enableInstruction {
      KVNProgress.show(withStatus: enableInstructionMessage)
    }
  }
  
  fileprivate func setupView() {
    if UserDefaults.standard.bool(forKey: "invisible") {
      self.invisible = true
    } else {
      self.invisible = false
    }
    
    if config.fetchComplete {
      updateCloudData()
    }
    config.loadingDoneCallback = updateCloudData
    
    tableView.reloadData()
    setNavigation(title: "Total 2LC Balance", largeTitle: true)
    
    settingsBarButtonItem()
  }
  
  fileprivate func getWalletByPublicKey() {
    guard let userData = DataProvider.shared.user else { return }
    var wallets: [Wallets] = []
    let tlc = Wallets(name: .TLocal,
                      balance: "\(userData.balance2lc)",
                      address: userData.wallet,
                      mnemonic: "",
                      displayName: Coins.TLocal.name())
    wallets.append(tlc)
    
    let bnb = Wallets(name: .Binance,
                      balance: "\(userData.balanceBnb)",
                      address: userData.wallet,
                      mnemonic: "",
                      displayName: Coins.Binance.name())
    wallets.append(bnb)
    
    refresfView(wallets)
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
          if transfer.source == "out" || transfer.from?.lowercased() == transfer.wallet?.address.lowercased() {
            month.expenses +=  Float(transfer.quantity ?? "0.0")!
          } else if transfer.source == "in" || transfer.to?.lowercased() == transfer.wallet?.address.lowercased() {
            month.income +=  Float(transfer.quantity ?? "0.0")!
          }
        }
      }
    }
    
    maxIncome = transactionsChart.map({$0.income}).max()
    maxExpense = transactionsChart.map({$0.expenses}).max()
  }
  
  fileprivate func refresfView(_ wallets: [Wallets]) {
    walletQueue.async {
      self.getTotalFiat(wallets) { totalFiat in
        self.totalfiatWithSymbol = self.defaultSym + "\(totalFiat)".convertToPriceType()
        DispatchQueue.main.async {
          self.tableView.reloadRows(at: self.indexPath(at: 0), with: .automatic)
        }
      }
      
      self.get2localBalance(wallets) { tlcBalance in
        self.totalTokenWithSymbol = "\(tlcBalance)".convertToPriceType() + " 2LC"
        DispatchQueue.main.async {
          self.tableView.reloadRows(at: self.indexPath(at: 0), with: .automatic)
        }
      }
      
      self.getTransactions(wallets) { transfers in
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
    defaultSym = DataProvider.shared.exchangeRate?.defaultSym ?? "$"
    wallets = DataProvider.shared.wallets
    tableView.reloadData()
    if wallets.count > 0 {
      refresfView(wallets)
    } else {
      getWalletByPublicKey()
    }
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
    let vc = UIStoryboard.dashboard.instantiate(viewController: TransactionsViewController.self)
    vc.initWith(self.transfers)
    if let navigation = navigationController {
      navigation.pushViewController(vc, animated: true)
    }
  }
  
  
}

//
//  WalletsListVC.swift
//  2local
//
//  Created by Ebrahim Hosseini on 4/1/21.
//  Copyright © 2021 2local Inc. All rights reserved.
//

import UIKit
import KVNProgress

class WalletsListVC: BaseVC {
    
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addWalletItems: UIBarButtonItem!
    
    //MARK: - Properties
    private var wallets: [Wallets] = []
    
    //MARK: - View cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(generateWallets),
                                               name: Notification.Name.wallet,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(refreshView),
                                               name: Notification.Name.walletRename,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(generateWallets),
                                               name: Notification.Name.walletRemove,
                                               object: nil)
        
        setupView()
        setupTable()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        KVNProgress.show(withStatus: "", on: view)
        generateWallets()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: - Functions
    fileprivate func setupView() {
        setNavigation(title: "Wallets", largTitle: true)
    }
    
    @objc fileprivate func refreshView() {
        self.tableView.reloadData()
    }
    
    @objc fileprivate func generateWallets() {
        wallets = DataProvider.shared.wallets
        self.tableView.reloadData()
        self.tableView.refreshControl?.endRefreshing()
        KVNProgress.dismiss()
    }
    
    //MARK: - Actions
    @IBAction func addWalletTapped(_ sender: UIBarButtonItem) {
        let vc = UIStoryboard.wallet.instantiate(viewController: AddNewWalletVC.self)
        vc.initwith(self.wallets)
        let navc = TLNavigationController(rootViewController: vc)
        if let navigation = navigationController {
            navigation.present(navc, animated: true)
        }
    }
}

//MARK: - table view
extension WalletsListVC: UITableViewDelegate, UITableViewDataSource {
    
    func setupTable() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        
        tableView.register(WalletListTableViewCell.self)
        
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = true
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorInset.left = 16
        tableView.separatorInset.right = 16
        tableView.separatorStyle = .none
        tableView.allowsSelection = true
        tableView.isScrollEnabled = true
        tableView.tableFooterView = UIView()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(generateWallets), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wallets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(WalletListTableViewCell.self)
        cell.selectionStyle = .none
        let row = indexPath.row
        cell.fill(wallets[row], index: row)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let row = indexPath.row
        let vc = UIStoryboard.wallet.instantiate(viewController: WalletDetailsVC.self)
        vc.initWith(wallets[row], index: row)
        if let navigation = navigationController {
            navigation.pushViewController(vc, animated: true)
        }
    }
}

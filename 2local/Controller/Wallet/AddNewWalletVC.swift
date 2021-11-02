//
//  WalletVC.swift
//  2local
//
//  Created by Ebrahim Hosseini on 3/23/21.
//  Copyright © 2021 2local Inc. All rights reserved.
//

import UIKit

class AddNewWalletVC: BaseVC {

    
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var importWalletButton: UIButton!
    
    //MARK: - Properties
    private var isSelected = false
    private var index: IndexPath?
    private var coins = [Coins.Ethereum, Coins.TLocal]
    private var coinsSelected: [Wallets] = []
    
    func initwith(_ coins: [Wallets]) {
        self.coinsSelected = coins
    }
    
    //MARK: - View cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: - Functions
    fileprivate func setupView() {
        setupTable()
        setNavigation(title: "Add New Wallet")
        
        createButton.setCornerRadius(8)
        createButton.isHidden = true
        
        importWalletButton.isHidden = true
    }
    
    @IBAction func closeButtonTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    @IBAction func createETHWallet(_ sender: UIButton) {
        let vc = UIStoryboard.wallet.instantiate(viewController: CreateETHWalletVC.self)
        vc.initWith(walletName: coins[index!.row])
        if let navigation = navigationController {
            navigation.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func importExistWallet(_ sender: UIButton) {
        let vc = UIStoryboard.wallet.instantiate(viewController: RecoveryPhraseVC.self)
        vc.initWith(coins[index!.row])
        if let navigation = navigationController {
            navigation.pushViewController(vc, animated: true)
        }
    }
    
}

//MARK: - table view
extension AddNewWalletVC: UITableViewDelegate, UITableViewDataSource {
    
    func setupTable() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        
        tableView.register(WalletTableViewCell.self)
        
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = true
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorInset.left = 16
        tableView.separatorInset.right = 16
        tableView.separatorStyle = .none
        tableView.allowsSelection = true
        tableView.isScrollEnabled = false
        tableView.tableFooterView = UIView()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        coins.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(WalletTableViewCell.self)
        cell.selectionStyle = .none
        let isSelected = (index == indexPath && self.isSelected)
        var isDisable = false
        if coinsSelected.filter({$0.name == coins[indexPath.row]}).first != nil {
           isDisable = true
        }
        
        cell.fill(isSelected, isDisable: isDisable, coin: self.coins[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if coinsSelected.filter({$0.name == coins[indexPath.row]}).first != nil {
           return
        }
        
        createButton.isEnabled = true
        createButton.alpha = 1
        
        let previuseIndex = self.index
        self.index = indexPath
        
        if previuseIndex == indexPath {
            isSelected = !isSelected
            createButton.isHidden = !isSelected
            importWalletButton.isHidden = !isSelected
        } else {
            isSelected = true
            createButton.isHidden = false
            importWalletButton.isHidden = false
        }
        if coins[indexPath.row] == Coins.TLocal {
            createButton.isEnabled = false
            createButton.alpha = 0.7
        }
        tableView.reloadData()
    }
}

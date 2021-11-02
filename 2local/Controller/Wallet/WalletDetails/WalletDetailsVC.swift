//
//  WalletDetailsVC.swift
//  2local
//
//  Created by Ebrahim Hosseini on 4/2/21.
//  Copyright © 2021 2local Inc. All rights reserved.
//

import UIKit
import KVNProgress

class WalletDetailsVC: BaseVC {
    
    //MARK: - Outlets
    @IBOutlet weak var walletTitleLabel: UILabel!
    @IBOutlet weak var walletIconImageView: UIImageView!
    @IBOutlet weak var walletContainerView: UIView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var receiveButton: UIButton!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var balanceCoinLabel: UILabel!
    @IBOutlet weak var balanceCoinTypeLabel: UILabel!
    @IBOutlet weak var balanceFiatLabel: UILabel!
    @IBOutlet weak var transactionSegmentedControl: SegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyBoxStack: UIStackView!
    @IBOutlet weak var percentChangeLabel: UILabel!
    
    //MARK: - Properties
    private var wallet: Wallets?
    private let window = UIApplication.shared.windows.filter{$0.isKeyWindow}.first
    private var isShowPopup: Bool = false
    private var rect = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    var transactionHistory: [Any] = []
    var transactions = DataProvider.shared.transfers
    var all2LCTransactions = [Transfer]()
    
    let attributes : [NSAttributedString.Key : Any] = [NSAttributedString.Key.foregroundColor : UIColor._logan, NSAttributedString.Key.font : UIFont.TLFont(weight: .regular, size: 13)]
    let selectedAttributes : [NSAttributedString.Key : Any] = [NSAttributedString.Key.foregroundColor : UIColor._flamenco,NSAttributedString.Key.font : UIFont.TLFont(weight: .medium, size: 13)]
    var allTransactions = [TransactionHistoryModel]()
    
    var index = 0
    private var indexId = 0
    
    var currentWallet: WalletProtocol!
    
    func initWith(_ wallet: Wallets, index: Int) {
        self.wallet = wallet
        self.indexId = index
    }
    
    //MARK: - View cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTable()
        setupSegmant()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(refreshView),
                                               name: Notification.Name.walletRename,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(popToView),
                                               name: Notification.Name.walletRemove,
                                               object: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getTransactionHistory()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - Functions
    fileprivate func setupView() {
        
        emptyBoxStack.isHidden = true
        
        walletContainerView.setCornerRadius(10)
        walletContainerView.setShadow(color: ._000372,
                                      opacity: 0.7,
                                      offset: CGSize(width: 1, height: 1),
                                      radius: 10)
        
        buyButton.setBorderWith(._E0E0EB, width: 1)
        buyButton.setTitle("Buy", for: .normal)
        buyButton.titleLabel?.font = .TLFont(weight: .medium, size: 14, style: .body)
        buyButton.titleLabel?.textColor = ._EF8749
        buyButton.setCornerRadius(8)
        buyButton.backgroundColor = ._F2F2F8
        buyButton.addTarget(self, action: #selector(buyTapped), for: .touchUpInside)
        
        sendButton.setImage(UIImage(named: "up"), for: .normal)
        sendButton.setTitle("Send", for: .normal)
        sendButton.titleLabel?.font = .TLFont(weight: .medium, size: 14, style: .body)
        sendButton.titleLabel?.textColor = .white
        sendButton.titleEdgeInsets.left = 12
        sendButton.setCornerRadius(8)
        sendButton.backgroundColor = wallet?.name == .TLocal ? ._solitude : ._mediumSlateBlue
        sendButton.contentEdgeInsets.left = -8
        sendButton.addTarget(self, action: #selector(sendTapped), for: .touchUpInside)
        
        receiveButton.setImage(UIImage(named: "down"), for: .normal)
        receiveButton.setTitle("Receive", for: .normal)
        receiveButton.titleLabel?.font = .TLFont(weight: .medium, size: 14, style: .body)
        receiveButton.titleLabel?.textColor = .white
        receiveButton.titleEdgeInsets.left = 12
        receiveButton.setCornerRadius(8)
        receiveButton.backgroundColor = wallet?.name == .TLocal ? ._solitude : ._shamrock
        receiveButton.contentEdgeInsets.left = -8
        receiveButton.addTarget(self, action: #selector(receiveTapped), for: .touchUpInside)
        
        refreshView()
    }
    
    @objc fileprivate func popToView() {
        self.index -= 1
        navigationController?.popViewController(animated: true)
    }
    
    @objc fileprivate func refreshView() {
        guard let wallet = self.wallet else { return }
        currentWallet = WalletFactory.getWallets(wallet: wallet)
        
        walletTitleLabel.text = currentWallet.name
        
        buyButton.isHidden = true//wallet.name != .TLocal
        
        walletIconImageView.image = UIImage(named: currentWallet.icon)
        
        balanceCoinTypeLabel.text = currentWallet.symbol
        
        percentChangeLabel.text = ""
        walletQueue.async { [self] in
            
            let balance = currentWallet.balance()
            DispatchQueue.main.async {
                balanceCoinLabel.text = balance.convertToPriceType()
            }
            
            currentWallet.fiat(from: Double(balance)) { (fiat) in
                DispatchQueue.main.async {
                    balanceFiatLabel.text = wallet.currencySymbol + fiat
                }
            }
        }
    }
    
    @objc fileprivate func buyTapped() {
        let vc = UIStoryboard.main.instantiate(viewController: Buy2LCViewController.self)
        if let navigation = self.navigationController {
            navigation.pushViewController(vc, animated: true)
        }
    }
    
    @objc fileprivate func sendTapped() {
        let vc = UIStoryboard.transaction.instantiate(viewController: SendViewController.self)
        guard let wallet = self.wallet else { return }
        vc.initWith(wallet)
        if let navigation = self.navigationController {
            navigation.pushViewController(vc, animated: true)
        }
    }
    
    @objc fileprivate func receiveTapped() {
        let vc = UIStoryboard.home.instantiate(viewController: ReceiveViewController.self)
        guard let wallet = self.wallet else { return }
        vc.initWith(wallet)
        if let navigation = self.navigationController {
            navigation.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func menuTapped(_ sender: UIBarButtonItem) {
        let vc = UIStoryboard.wallet.instantiate(viewController: PopoverMenuVC.self)
        vc.modalPresentationStyle = .popover
        vc.preferredContentSize = CGSize(width: 180, height: 100)
        vc.delegate = self
        //        vc.enableRemoveButton = wallet?.name == .TLocal ? false : true
        if let popoverPresentationController = vc.popoverPresentationController {
            popoverPresentationController.barButtonItem = sender
            popoverPresentationController.sourceRect = CGRect(x: 0, y: 0, width: 180, height: 100)
            popoverPresentationController.delegate = self
            
            self.present(vc, animated: true, completion: nil)
        }
    }
}

//MARK: - table view
extension WalletDetailsVC: UITableViewDelegate, UITableViewDataSource {
    
    func setupTable() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        
        tableView.register(TransactionHistoryTableViewCell.self)
        
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = true
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorInset.left = 16
        tableView.separatorInset.right = 16
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.tableFooterView = UIView()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(TransactionHistoryTableViewCell.self)
        if self.transactionHistory.count > 0, let wallet = self.wallet {
            cell.fill(transactionHistory[indexPath.row], wallet: wallet)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

//MARK: - Popover delegate
extension WalletDetailsVC: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        .none
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        
    }
    
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        true
    }
}

//MARK: - Popup wallet protocol
protocol PopupActions {
    func popoverRenameWallet()
    func popoverRemoveWallet()
}


//MARK: - Show edit view
extension WalletDetailsVC: PopupActions {
    func popoverRenameWallet() {
        let vc = UIStoryboard.wallet.instantiate(viewController: EditWalletVC.self)
        vc.modalPresentationStyle = .overFullScreen
        if let wallet = self.wallet {
            vc.initWith(.rename, wallet: wallet)
        }
        present(vc, animated: true)
    }
    
    func popoverRemoveWallet() {
        let vc = UIStoryboard.wallet.instantiate(viewController: EditWalletVC.self)
        vc.modalPresentationStyle = .overFullScreen
        if let wallet = self.wallet {
            vc.initWith(.remove, wallet: wallet)
        }
        present(vc, animated: true)
    }
}

//MARK: - Segment
extension WalletDetailsVC: SegmentedControlDelegate {
    
    func setupSegmant() {
        self.transactionSegmentedControl.setTitles(
            [NSAttributedString(string: "All", attributes: attributes),
             NSAttributedString(string: "Purchase", attributes: attributes),
             NSAttributedString(string: "Received", attributes: attributes),
             NSAttributedString(string: "Sent", attributes: attributes)],
            selectedTitles:
                [NSAttributedString(string: "All", attributes: selectedAttributes),
                 NSAttributedString(string: "Purchase", attributes: selectedAttributes),
                 NSAttributedString(string: "Received", attributes: selectedAttributes),
                 NSAttributedString(string: "Sent", attributes: selectedAttributes)])
        self.transactionSegmentedControl.delegate = self
        self.transactionSegmentedControl.selectionBoxStyle  = .default
        self.transactionSegmentedControl.selectionBoxColor = .clear
        self.transactionSegmentedControl.selectionIndicatorStyle = .bottom
        self.transactionSegmentedControl.selectionIndicatorColor = ._flamenco
        self.transactionSegmentedControl.selectionIndicatorHeight = 1
        self.transactionSegmentedControl.selectionIndicatorEdgeInsets = UIEdgeInsets(top: 0, left: 32, bottom: 0, right: 31)
    }
    
    func segmentedControl(_ segmentedControl: SegmentedControl, didSelectIndex selectedIndex: Int) {
        switch selectedIndex {
            case 0:
                self.transactionSegmentedControl.selectionIndicatorEdgeInsets = UIEdgeInsets(top: 0, left: 32, bottom: 0, right: 31)
                self.transactionHistory = allTransactions
            case 1:
                self.transactionSegmentedControl.selectionIndicatorEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 11)
                self.transactionHistory = []
            case 2:
                self.transactionSegmentedControl.selectionIndicatorEdgeInsets = UIEdgeInsets(top: 0, left: 13, bottom: 0, right: 12)
                self.transactionHistory = allTransactions.filter{ $0.to == self.wallet!.address.lowercased() }
            case 3:
                self.transactionSegmentedControl.selectionIndicatorEdgeInsets = UIEdgeInsets(top: 0, left: 27, bottom: 0, right: 26)
                self.transactionHistory = allTransactions.filter{ $0.from == self.wallet!.address.lowercased() }
                
            default:
                break
        }
        if selectedIndex < self.index {
            tableView.reloadSections(IndexSet.init(integer: 0), with: .right)
        }
        else if selectedIndex > self.index {
            tableView.reloadSections(IndexSet.init(integer: 0), with: .left)
        }
        
        self.index = selectedIndex
        
        emptyBoxStack.isHidden = transactionHistory.count != 0
        
    }
    
}

//
//  TransactionReciptVC.swift
//  2local
//
//  Created by Ebrahim Hosseini on 6/7/21.
//  Copyright © 2021 2local Inc. All rights reserved.
//

import UIKit

class TransactionReciptVC: BaseVC {
    
    //MARK: - Outlets
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var txHashLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var shareButton: UIButton!
    
    //MARK: - Properties
    private var to: String?
    private var amount: Decimal?
    private var coin: Coins?
    private var txHash: String?
    private var amountFiat: String = "0"
    private var wallet: Wallets?
    
    func initWith(_ to: String, amount: Decimal, amountFiat: String, coin: Coins, txHash: String, wallet: Wallets) {
        self.to = to
        self.amount = amount
        self.coin = coin
        self.txHash = txHash
        self.amountFiat = amountFiat
        self.wallet = wallet
    }
    
    //MARK: - View cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        updateBalance()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: - Functions
    fileprivate func setupView() {
        doneButton.setCornerRadius(8)
        containerView.setCornerRadius(25)
        containerView.setShadow(color: UIColor._707070,
                                opacity: 0.5,
                                offset: CGSize(width: 0, height: 0),
                                radius: 10.0)
        
        toLabel.text = to
        toLabel.numberOfLines = 0
        
        amountLabel.text = "\(amount ?? 0)" + " \(coin!.symbol())" + " ~ \(amountFiat)"
        
        txHashLabel.numberOfLines = 0
        txHashLabel.text = txHash
    }
    
    fileprivate func updateBalance() {
        guard let wallet = self.wallet else { return }
        let currentWallet = WalletFactory.getWallets(wallet: wallet)
        
        walletQueue.async {
            let balance = currentWallet.balance()
            
            var updateWallet = DataProvider.shared.wallets
            
            if let row = updateWallet.firstIndex(where: {$0.name == currentWallet.wallet.name}) {
                guard let coin = Coins(rawValue: currentWallet.name) else { return }
                let newWallet = Wallets(name: coin,
                                           balance: balance,
                                           address: currentWallet.address,
                                           mnemonic: currentWallet.wallet.mnemonic,
                                           displayName: currentWallet.wallet.displayName)
                
                updateWallet[row] = newWallet
            }
        }
    }
    
    //MARK: - Actions
    @IBAction func doneTapped(_ sender: UIButton) {
        navigationController?.dismiss(animated: true)
    }
    
    @IBAction func shareTapped(_ sender: UIButton) {
        guard let txHash = txHash else { return }
        let shareUrl = "https://etherscan.io/tx/\(txHash)"
        
        // Setting url
        let secondActivityItem : URL = URL(string: shareUrl)!
        
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [secondActivityItem], applicationActivities: nil)
        
        // This lines is for the popover you need to show in iPad
        activityViewController.popoverPresentationController?.sourceView = (sender)
        
        // This line remove the arrow of the popover to show in iPad
        activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.down
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
        
        // Pre-configuring activity items
        if #available(iOS 13.0, *) {
            activityViewController.activityItemsConfiguration = [ UIActivity.ActivityType.message ] as? UIActivityItemsConfigurationReading
        } else {
            // Fallback on earlier versions
        }
        
        // Anything you want to exclude
        activityViewController.excludedActivityTypes = [
            UIActivity.ActivityType.postToWeibo,
            UIActivity.ActivityType.print,
            UIActivity.ActivityType.assignToContact,
            UIActivity.ActivityType.saveToCameraRoll,
            UIActivity.ActivityType.addToReadingList,
            UIActivity.ActivityType.postToFlickr,
            UIActivity.ActivityType.postToVimeo,
            UIActivity.ActivityType.postToTencentWeibo,
            UIActivity.ActivityType.postToFacebook
        ]
        
        if #available(iOS 13.0, *) {
            activityViewController.isModalInPresentation = true
        } else {
            // Fallback on earlier versions
        }
        self.present(activityViewController, animated: true, completion: nil)
    }
    
}

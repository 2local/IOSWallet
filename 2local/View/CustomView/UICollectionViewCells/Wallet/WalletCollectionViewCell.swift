//
//  WalletCollectionViewCell.swift
//  2local
//
//  Created by Ebrahim Hosseini on 3/28/21.
//  Copyright © 2021 2local Inc. All rights reserved.
//

import UIKit

class WalletCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Outlets
    @IBOutlet weak var walletLogoImageView: UIImageView!
    @IBOutlet weak var coinBalanceLabel: UILabel!
    @IBOutlet weak var coinSymbolLabel: UILabel!
    @IBOutlet weak var fiatBalanceLabel: UILabel!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var receiveButton: UIButton!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var itemWidth: NSLayoutConstraint!
    
    //MARK: - properties
    var buyButtonCallback: SimpleAction = nil
    var sendButtonCallback: SimpleAction = nil
    var receiveButtonCallback: SimpleAction = nil
    
    //MARK: - cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.backgroundColor = ._F2F2F8
        containerView.setBorderWith(._E0E0EB, width: 1)
        containerView.setCornerRadius(10)
        
        walletLogoImageView.image = UIImage(named: "logo")
        walletLogoImageView.contentMode = .scaleAspectFit
        
        coinBalanceLabel.font = .TLFont(weight: .medium, size: 18, style: .body)
        coinBalanceLabel.textColor = ._202020
        coinBalanceLabel.adjustsFontSizeToFitWidth = true
        
        coinSymbolLabel.font = .TLFont(weight: .regular, size: 14, style: .body)
        coinSymbolLabel.textColor = ._575757
        
        fiatBalanceLabel.font = .TLFont(weight: .regular, size: 14, style: .body)
        fiatBalanceLabel.textColor = ._707070
        
        buyButton.setBorderWith(._E0E0EB, width: 1)
        buyButton.setTitle("Buy", for: .normal)
        buyButton.titleLabel?.font = .TLFont(weight: .medium, size: 14, style: .body)
        buyButton.titleLabel?.textColor = ._EF8749
        buyButton.setCornerRadius(5)
        buyButton.backgroundColor = ._F2F2F8
        
        sendButton.setImage(UIImage(named: "up"), for: .normal)
        sendButton.setTitle("Send", for: .normal)
        sendButton.titleLabel?.font = .TLFont(weight: .medium, size: 14, style: .body)
        sendButton.titleLabel?.textColor = .white
        sendButton.titleEdgeInsets.left = 12
        sendButton.setCornerRadius(8)
        sendButton.backgroundColor = ._mediumSlateBlue
        sendButton.contentEdgeInsets.left = -8
        
        receiveButton.setImage(UIImage(named: "down"), for: .normal)
        receiveButton.setTitle("Receive", for: .normal)
        receiveButton.titleLabel?.font = .TLFont(weight: .medium, size: 14, style: .body)
        receiveButton.titleLabel?.textColor = .white
        receiveButton.titleEdgeInsets.left = 12
        receiveButton.setCornerRadius(8)
        receiveButton.backgroundColor = ._shamrock
        receiveButton.contentEdgeInsets.left = -8
        
    }
    
    //MARK: - functions
    func fill(_ wallet: Wallets, invisible: Bool) {
        buyButton.isHidden = true

        walletQueue.async {
            let currentWallet = WalletFactory.getWallets(wallet: wallet)
            
            let balance = currentWallet.balance()
            
            DispatchQueue.main.async {
                self.coinBalanceLabel.text = invisible ? "****" : balance.convertToPriceType()
                self.coinSymbolLabel.text = invisible ? "" : currentWallet.symbol
                self.walletLogoImageView.image = UIImage(named: currentWallet.icon)
            }
            
            let fiatSymbol = DataProvider.shared.exchangeRate?.defaultSym ?? "$"
            
            currentWallet.fiat(from: Double(balance)) { (fiat) in
                DispatchQueue.main.async {
                    self.fiatBalanceLabel.text = invisible ? "****" : fiatSymbol + fiat
                }
            }
        }
        
        itemWidth.constant = UIScreen.main.bounds.width - 24
    }
    
    
    static func getHeight() -> CGFloat {
        return 190
    }
    
    @IBAction func buyTapped(_ sender: UIButton) {
        buyButtonCallback?()
    }
    
    @IBAction func sendTapped(_ sender: UIButton) {
        sendButtonCallback?()
    }
    
    @IBAction func receiveTapped(_ sender: UIButton) {
        receiveButtonCallback?()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        coinBalanceLabel.text = "0"
        fiatBalanceLabel.text = "$0"
    }
}

//
//  WalletListTableViewCell.swift
//  2local
//
//  Created by Ebrahim Hosseini on 4/1/21.
//  Copyright © 2021 2local Inc. All rights reserved.
//

import UIKit

class WalletListTableViewCell: UITableViewCell {

    @IBOutlet weak var contanerView: UIView!
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var walletLogoImageView: UIImageView!
    @IBOutlet weak var walletNameLabel: UILabel!
    @IBOutlet weak var walletBalanceLabal: UILabel!
    @IBOutlet weak var walletSymbolLabel: UILabel!
    @IBOutlet weak var walletFiatBalanceLabel: UILabel!
    @IBOutlet weak var walletFiatSymbolLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        contanerView.backgroundColor = .f2f2f8
        contanerView.setBorderWith(.e0e0eb, width: 1)
        contanerView.setCornerRadius(8)

        imageContainerView.setBorderWith(.e0e0eb, width: 1)
        imageContainerView.makeItCapsuleOrCircle()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func fill(_ wallet: Wallets, index: Int) {

        walletFiatSymbolLabel.text = wallet.currency

        let currentWallet = WalletFactory.getWallets(wallet: wallet)

        walletQueue.async { [self] in

            let balance = currentWallet.balance()
            DispatchQueue.main.async {
                walletBalanceLabal.text = balance.convertToPriceType()
            }

            currentWallet.fiat(from: Double(balance)) { (fiat) in
                DispatchQueue.main.async {
                    walletFiatBalanceLabel.text = fiat
                }
            }
        }

        walletLogoImageView.image = UIImage(named: currentWallet.icon)
        walletNameLabel.text = currentWallet.name
        walletSymbolLabel.text = currentWallet.symbol
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        walletFiatSymbolLabel.text = "USD"
        walletFiatBalanceLabel.text = "0"
    }
}

//
//  WalletTableViewCell.swift
//  2local
//
//  Created by Ebrahim Hosseini on 3/30/21.
//  Copyright © 2021 2local Inc. All rights reserved.
//

import UIKit

class WalletTableViewCell: UITableViewCell {

    @IBOutlet weak var contanerView: UIView!
    @IBOutlet weak var coinImageView: UIImageView!
    @IBOutlet weak var coinTitleLabel: UILabel!
    @IBOutlet weak var coinContainerView: UIView!
    @IBOutlet weak var checkImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()

        contanerView.backgroundColor = .f2f2f8
        contanerView.setBorderWith(.e0e0eb, width: 1)
        contanerView.setCornerRadius(8)

        coinContainerView.setBorderWith(.e0e0eb, width: 1)
        coinContainerView.makeItCapsuleOrCircle()

        coinImageView.contentMode = .scaleAspectFit

        coinTitleLabel.font = .TLFont(weight: .regular, size: 15, style: .body)

        checkImageView.isHidden = true
    }

    func fill(_ isSelected: Bool, isDisable: Bool, coin: Coins) {

        coinImageView.image = UIImage(named: coin.icon())
        coinTitleLabel.text = coin.name()

        if isDisable {
            coinTitleLabel.textColor = .color707070
            coinContainerView.backgroundColor = .f2f2f8
            return
        }

        checkImageView.isHidden = !isSelected
        if isSelected {
            contanerView.setBorderWith(.shamrock, width: 1)
        } else {
            contanerView.setBorderWith(.e0e0eb, width: 1)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

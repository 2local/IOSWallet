//
//  TransactionHistoryTableViewCell.swift
//  2local
//
//  Created by Ebrahim Hosseini on 4/22/21.
//  Copyright © 2021 2local Inc. All rights reserved.
//

import UIKit

class TransactionHistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var transactionTitleLabel: UILabel!
    @IBOutlet weak var transactionDateLabel: UILabel!
    @IBOutlet weak var transactionIconImageView: UIImageView!
    @IBOutlet weak var transactionAmountLabel: UILabel!
    @IBOutlet weak var transactionAmountFiatLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!

    var isMine = false

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func fill<T>(_ data: T, wallet: Wallets) {
        if let data = data as? TransactionHistoryModel {
            guard let address = data.from else { return }
            self.isMine = address == wallet.address.lowercased() ? true : false

            transactionDateLabel.text = data.timeStamp?.toMonth()
            transactionAmountFiatLabel.isHidden = true
            stateLabel.text = "Complete"
            stateLabel.textColor = isMine ? .FE6C6C : .shamrock

            transactionTitleLabel.text = isMine ? TransactionType.sent.title() : TransactionType.received.title()

            let icon = isMine ? TransactionType.sent.icon() : TransactionType.received.icon()
            transactionIconImageView.image = UIImage(named: icon)

            let pow = pow(10, 18)
            let value = Decimal(string: data.value ?? "0")!
            let amount = value/pow

            let prefixSign = isMine ? "-" : "+"
            transactionAmountLabel.text = "\(prefixSign) \(amount) \(wallet.name.symbol())"
            transactionAmountLabel.textColor = isMine ? .FE6C6C : .shamrock
        }

        if let data = data as? Transfer {
            guard let address = data.from else { return }
            self.isMine = address == wallet.address.lowercased() ? true : false

            transactionDateLabel.text = data.date?.toMonth()
            transactionAmountFiatLabel.isHidden = true
            stateLabel.text = "Complete"
            stateLabel.textColor = isMine ? .FE6C6C : .shamrock

            transactionTitleLabel.text = isMine ? TransactionType.sent.title() : TransactionType.received.title()

            let icon = isMine ? TransactionType.sent.icon() : TransactionType.received.icon()
            transactionIconImageView.image = UIImage(named: icon)

            let pow = pow(10, 18)
            let value = Decimal(string: data.amount ?? "0")!
            let amount = value/pow

            let prefixSign = isMine ? "-" : "+"
            transactionAmountLabel.text = "\(prefixSign) \(amount) \(wallet.name.symbol())"
            transactionAmountLabel.textColor = isMine ? .FE6C6C : .shamrock
        }
    }
}

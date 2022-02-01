//
//  TransactionTableViewCell.swift
//  2local
//
//  Created by Hasan Sedaghat on 1/22/20.
//  Copyright © 2020 2local Inc. All rights reserved.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {

    @IBOutlet var topView: UIView!
    @IBOutlet var dotView: UIView!
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var costLabel: UILabel!
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var stateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        topView.alpha = 0
        dotView.layer.cornerRadius = dotView.frame.width / 2
        dotView.layer.borderColor = UIColor.linkWater.cgColor
        dotView.layer.borderWidth = 1.5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}

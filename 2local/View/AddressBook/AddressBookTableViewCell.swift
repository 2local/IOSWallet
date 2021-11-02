//
//  AddressBookTableViewCell.swift
//  2local
//
//  Created by Hasan Sedaghat on 1/8/20.
//  Copyright © 2020 2local Inc. All rights reserved.
//

import UIKit

class AddressBookTableViewCell: UITableViewCell {

    @IBOutlet var removeBTN: UIButton!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var walletNumberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

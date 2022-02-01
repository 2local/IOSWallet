//
//  InfoTableViewCell.swift
//  2local
//
//  Created by Ibrahim Hosseini on 11/26/21.
//  Copyright © 2021 2local Inc. All rights reserved.
//

import UIKit

class InfoTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLable: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        titleLable.font = .TLFont(weight: .regular,
                                  size: 13,
                                  style: .body)
        titleLable.numberOfLines = 0
        titleLable.textColor = .bittersweet

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func fill(_ text: String) {
        titleLable.text = text
    }

}

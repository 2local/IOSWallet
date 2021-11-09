//
//  MarketInfo.swift
//  2local
//
//  Created by Hasan Sedaghat on 1/26/20.
//  Copyright © 2020 2local Inc. All rights reserved.
//

import UIKit

class MarketInfoView: UIView {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var directionButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var websiteLabel: UILabel!
    
    var callNumber = ""
    var lat = 0.0
    var lng = 0.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setShadow(color: UIColor._002CA4, opacity: 1, offset: CGSize(width: 0, height: 0), radius: 6)
        self.directionButton.setBorderWith(._flamenco, width: 1.2)
        
        websiteLabel.numberOfLines = 0
        nameLabel.numberOfLines = 0
    }

}

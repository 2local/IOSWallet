//
//  TLTabBar.swift
//  2local
//
//  Created by Hasan Sedaghat on 12/30/19.
//  Copyright © 2019 2local Inc. All rights reserved.
//

import UIKit

class TLTabBarView: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setShadow(color: UIColor.color002CA4, opacity: 1, offset: CGSize(width: 0, height: -3), radius: 10)
    }
}

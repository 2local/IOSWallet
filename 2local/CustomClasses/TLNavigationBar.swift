//
//  TLNavigationBar.swift
//  2local
//
//  Created by Hasan Sedaghat on 12/30/19.
//  Copyright © 2019 2local Inc. All rights reserved.
//

import UIKit

class TLNavigationBar: UINavigationBar {
    @IBInspectable var backImage: UIImage! = UIImage(named: "back")
    override func awakeFromNib() {
        super.awakeFromNib()

        let yourBackImage = backImage
        self.tintColor = .color606060
        self.backIndicatorImage = yourBackImage
        self.backIndicatorTransitionMaskImage = yourBackImage
        self.backItem?.title = " "
        self.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.color606060, NSAttributedString.Key.font: UIFont.TLFont(weight: .medium, size: 16)]
        self.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.color606060, NSAttributedString.Key.font: UIFont.TLFont(weight: .medium, size: 24)]
        self.isTranslucent = true
        self.barTintColor = .white
        self.setBackgroundImage(UIImage(), for: .default)
        self.shadowImage = UIImage()
        self.prefersLargeTitles = true
    }

}

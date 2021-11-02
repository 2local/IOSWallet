//
//  UITabbar+Height.swift
//  2local
//
//  Created by Ebrahim Hosseini on 7/27/21.
//  Copyright © 2021 2local Inc. All rights reserved.
//

import UIKit

extension UITabBar {
    var hasHomeIndicator: Bool {
        get {
            return UIApplication.shared.delegate?.window??.safeAreaInsets.bottom ?? .zero > 0
        }
    }
    
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        super.sizeThatFits(size)
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = hasHomeIndicator ? 89 : 70
        return sizeThatFits
    }
    
}

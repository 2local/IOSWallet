//
//  UIView+CornerRadius.swift
//  2local
//
//  Created by Ebrahim Hosseini on 3/29/21.
//  Copyright © 2021 2local Inc. All rights reserved.
//

import UIKit

extension UIView {

    func makeItCapsuleOrCircle() {
        if self.frame.height >= self.frame.width {
            self.layer.cornerRadius = self.frame.width / 2
        } else {
            self.layer.cornerRadius = self.frame.height / 2
        }

        self.layer.masksToBounds = true
    }

    func setCornerRadius(_ radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }

    func setCornerRadius(to corners: CACornerMask, radius: CGFloat) {
        clipsToBounds = true
        layer.cornerRadius = radius
        layer.maskedCorners = corners
    }

}

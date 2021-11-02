//
//  TLPageControl.swift
//  2local
//
//  Created by Hasan Sedaghat on 12/29/19.
//  Copyright © 2019 2local Inc. All rights reserved.
//

import UIKit

class TLPageControl: UIPageControl {

    var borderColor: UIColor = UIColor._404040

    override var currentPage: Int {
        didSet {
            updateBorderColor()
        }
    }

    func updateBorderColor() {
        subviews.enumerated().forEach { index, subview in
            if index != currentPage {
                subview.layer.borderColor = borderColor.cgColor
                subview.layer.borderWidth = 1
            } else {
                subview.layer.borderWidth = 0
            }
        }
    }
}

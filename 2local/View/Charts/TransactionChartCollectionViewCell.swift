//
//  TransactionChartCollectionViewCell.swift
//  2local
//
//  Created by Hasan Sedaghat on 1/24/20.
//  Copyright © 2020 2local Inc. All rights reserved.
//

import UIKit

class TransactionChartCollectionViewCell: UICollectionViewCell {

    @IBOutlet var monthLabel: UILabel!
    @IBOutlet var barView: UIView!
    @IBOutlet var incomeView: UIView!
    @IBOutlet var expenseView: UIView!
    @IBOutlet var incomeHeightConst: NSLayoutConstraint!
    @IBOutlet var expenseHeightConst: NSLayoutConstraint!
    @IBOutlet weak var indicatorView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        incomeHeightConst.constant = 0
        expenseHeightConst.constant = 0
        incomeView.layer.cornerRadius = 3
        incomeView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        expenseView.layer.cornerRadius = 3
        expenseView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        // expenseView.roundCorners(corners: [.bottomLeft,.bottomRight], radius: 4)
        // incomeView.roundCorners(corners: [.topLeft,.topRight], radius: 4)
    }

}

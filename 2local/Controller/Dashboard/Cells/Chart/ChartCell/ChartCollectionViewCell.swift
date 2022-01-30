//
//  ChartCollectionViewCell.swift
//  2local
//
//  Created by Ibrahim Hosseini on 10/11/21.
//  Copyright © 2021 2local Inc. All rights reserved.
//

import UIKit

class ChartCollectionViewCell: UICollectionViewCell {

    // MARK: - outlet
    @IBOutlet var monthLabel: UILabel!
    @IBOutlet var barView: UIView!
    @IBOutlet var incomeView: UIView!
    @IBOutlet var expenseView: UIView!
    @IBOutlet var incomeHeightConst: NSLayoutConstraint!
    @IBOutlet var expenseHeightConst: NSLayoutConstraint!
    @IBOutlet var chartWidth: NSLayoutConstraint!
    @IBOutlet weak var indicatorView: UIView!

    // MARK: - properties

    // MARK: - life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        incomeHeightConst.constant = 0
        expenseHeightConst.constant = 0
        incomeView.layer.cornerRadius = 3
        incomeView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        expenseView.layer.cornerRadius = 3
        expenseView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }

    func fill(_ transactionsChart: TransactionChartModel, transferCount: Int, maxVal: CGFloat, month: String) {

        monthLabel.text = month

        let maxIncomeHeight: CGFloat = barView.frame.height / 2
        let maxExpenseHeight: CGFloat = barView.frame.height / 2

        UIView.animate(withDuration: 0, animations: { [self] in
            incomeHeightConst.constant = 0
            expenseHeightConst.constant = 0
            barView.alpha = 0
            indicatorView.alpha = 1
        }) { [self] (_) in
            barView.alpha = 1
            indicatorView.alpha = 0
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
                barView.alpha = 1
                indicatorView.alpha = 0
                UIView.animate(withDuration: 1, delay: 0, options: [.curveEaseInOut], animations: {
                    incomeHeightConst.constant = (CGFloat(transactionsChart.income) * maxIncomeHeight / maxVal)
                    expenseHeightConst.constant =  (CGFloat(transactionsChart.expenses) * maxExpenseHeight / maxVal)
                    if (0...1).contains(incomeHeightConst.constant) && (0...1).contains(expenseHeightConst.constant ) || transferCount == 0 {
                        barView.alpha = 0
                        indicatorView.alpha = 1
                    }
                    if (0...1).contains(incomeHeightConst.constant) {
                        incomeHeightConst.constant = 4
                    }
                    if (0...1).contains(expenseHeightConst.constant) {
                        expenseHeightConst.constant = 4
                    }
                    barView.layoutIfNeeded()
                }) { (_) in

                }
            }
        }
    }

}

//
//  ChartSectionTableViewCell.swift
//  2local
//
//  Created by Ibrahim Hosseini on 10/10/21.
//  Copyright © 2021 2local Inc. All rights reserved.
//

import UIKit

class ChartSectionTableViewCell: UITableViewCell {
    
    //MARK: - outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: - properties
    let months = Date().getLast12Month.0
    var maxIncome : Float?
    var maxExpense : Float?
    var invisible = false
    var transactionsChart = [TransactionChartModel]()
    var transfers = [Transfer]()
    
    //MARK: - life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollection()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    //MARK: - functions
    func fill(_ transfers: [Transfer], invisible: Bool) {
        self.invisible = invisible
        self.transfers = transfers
        showTransfer(transfers)
    }
    
    func showTransfer(_ transfers: [Transfer]) {
        let months = Date().getLast12Month.1
        
        for month in months {
            let transaction = TransactionChartModel()
            transaction.date = month.prefix(7).description
            transactionsChart.append(transaction)
        }
        
        for month in transactionsChart {
            for transfer in transfers {
                if month.date == i.toMonthAndYear() {
                    if transfer.source == "out" || transfer.from?.lowercased() == transfer.wallet?.address.lowercased() {
                        month.expenses +=  Float(transfer.quantity ?? "0.0")!
                    } else if transfer.source == "in" || transfer.to?.lowercased() == transfer.wallet?.address.lowercased() {
                        month.income +=  Float(transfer.quantity ?? "0.0")!
                    }
                }
            }
        }
        
        maxIncome = transactionsChart.map({$0.income}).max()
        maxExpense = transactionsChart.map({$0.expenses}).max()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
}

//MARK: - collection view
extension ChartSectionTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func setupCollection() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(ChartCollectionViewCell.self)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(ChartCollectionViewCell.self, indexPath: indexPath)
        let row = indexPath.row
        if let maxIncome = self.maxIncome, let maxExpense = self.maxExpense {
            let maxVal: CGFloat = CGFloat(max(maxIncome, maxExpense))
            cell.fill(self.transactionsChart[row], transferCount: self.transfers.count, maxVal: maxVal, month: months[row])
        }
        return cell
    }
}

//MARK: - CollectionView FlowLayout Delegate
extension ChartSectionTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width / 12, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        .zero
    }
    
}

//
//  DashboardVC+TableView.swift
//  2local
//
//  Created by Ibrahim Hosseini on 10/10/21.
//  Copyright © 2021 2local Inc. All rights reserved.
//

import UIKit

//MARK: - table view
extension DashboardVC: UITableViewDelegate, UITableViewDataSource {
    
    func setupTable() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        
        tableView.register(BalanceSectionTableViewCell.self)
        tableView.register(ChartSectionTableViewCell.self)
        tableView.register(WalletListSectionTableViewCell.self)
        
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = true
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorInset.left = 16
        tableView.separatorInset.right = 16
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.tableFooterView = UIView()
        
        let refreshControll = UIRefreshControl()
        refreshControll.addTarget(self, action: #selector(generateWalets), for: .valueChanged)
        tableView.refreshControl = refreshControll
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        
        switch row {
            case 0:
                let cell = tableView.dequeue(BalanceSectionTableViewCell.self)
                cell.fill(self.totalfiatWithSymbol, tokenCount: self.totalTokenWithSymbol, invisible: self.invisible)
                
                cell.invisibleCallback = { [weak self] invisible in
                    guard let self = self else { return }
                    guard let invisible = invisible else { return }
                    self.invisible = invisible
                    self.tableView.reloadRows(at: self.indexPath(at: 1), with: .automatic)
                }
                
                return cell
            case 1:
                let cell = tableView.dequeue(WalletListSectionTableViewCell.self)
                cell.fill(self, wallets: self.wallets, invisible: self.invisible)
                return cell
            default:
                let cell = tableView.dequeue(ChartSectionTableViewCell.self)
                cell.fill(self.transfers, invisible: self.invisible)
                return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

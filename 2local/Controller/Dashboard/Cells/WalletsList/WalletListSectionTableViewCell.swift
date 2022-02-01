//
//  WalletListTableViewCell.swift
//  2local
//
//  Created by Ibrahim Hosseini on 10/10/21.
//  Copyright © 2021 2local Inc. All rights reserved.
//

import UIKit

class WalletListSectionTableViewCell: UITableViewCell {

    // MARK: - outlets
    @IBOutlet weak var collectionView: UICollectionView!

    // MARK: - properties
    private var wallets: [Wallets] = []
    private var viewController: DashboardVC!
    private var invisible: Bool = false

    // MARK: - life cycle
    override func awakeFromNib() {
        super.awakeFromNib()

        setupCollection()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // MARK: - functions
    func fill(_ viewController: DashboardVC, wallets: [Wallets], invisible: Bool) {
        self.wallets = wallets
        self.invisible = invisible
        self.viewController = viewController
        collectionView.reloadData()
    }

    // MARK: - actions

}

// MARK: - collection view
extension WalletListSectionTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {

    func setupCollection() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset.left = 16

        collectionView.register(AddNewWalletCollectionViewCell.self)
        collectionView.register(WalletCollectionViewCell.self)

    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return wallets.count + 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let row = indexPath.row
        if row == wallets.count {
            let cell = collectionView.dequeue(AddNewWalletCollectionViewCell.self, indexPath: indexPath)
            cell.addNewWalletButtonCallback = { [weak self] in
                guard let self = self else { return }
                let vc = UIStoryboard.wallet.instantiate(viewController: AddNewWalletVC.self)
                vc.initwith(self.wallets)
                let navc = TLNavigationController(rootViewController: vc)
                self.viewController.present(navc, animated: true)

            }
            return cell
        } else {
            let cell = collectionView.dequeue(WalletCollectionViewCell.self, indexPath: indexPath)

            let wallet = self.wallets[row]

            cell.fill(wallet, invisible: self.invisible)

            cell.buyButtonCallback = { [weak self] in
                guard let self = self else { return }
                let vc = UIStoryboard.buy.instantiate(viewController: Buy2LCViewController.self)
                if let navigation = self.viewController.navigationController {
                    navigation.pushViewController(vc, animated: true)
                }
            }

            cell.receiveButtonCallback = { [weak self] in
                guard let self = self else { return }
                let vc = UIStoryboard.dashboard.instantiate(viewController: ReceiveViewController.self)
                vc.initWith(wallet)
                if let navigation = self.viewController.navigationController {
                    navigation.pushViewController(vc, animated: true)
                }
            }

            cell.sendButtonCallback = { [weak self] in
                guard let self = self else { return }
                let vc = UIStoryboard.transaction.instantiate(viewController: SendViewController.self)
                vc.initWith(wallet)
                if let navigation = self.viewController.navigationController {
                    navigation.pushViewController(vc, animated: true)
                }
            }

            return cell
        }

    }
}

// MARK: - CollectionView FlowLayout Delegate
extension WalletListSectionTableViewCell: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 24, height: WalletCollectionViewCell.getHeight())
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        .zero
    }

}

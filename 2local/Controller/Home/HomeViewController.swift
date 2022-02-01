//
//  HomeViewController.swift
//  2local
//
//  Created by Hasan Sedaghat on 12/31/19.
//  Copyright © 2019 2local Inc. All rights reserved.
//

import UIKit
import KVNProgress

class HomeViewController: UIViewController {

    @IBOutlet var creditLabel: UILabel!
    @IBOutlet var balanceLabel: UILabel!
    @IBAction func unwindToHome(segue: UIStoryboardSegue) { }
    @IBOutlet var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }

    @IBOutlet var websiteLinkLabel: UILabel!
    @IBOutlet var invisibleBTN: UIButton!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var receiveButton: UIButton!

    let months = Date().getLast12Month.0
    var transfers = DataProvider.shared.transfers
    var transactions = [TransactionChartModel]()
    var maxIncome: Float?
    var maxExpense: Float?
    var invisible = false

    override func viewDidLoad() {
        super.viewDidLoad()

        buyButton.layer.cornerRadius = 5
        buyButton.clipsToBounds = true
        DispatchQueue.main.async {
            self.buyButton.backgroundColor = ._solitude
            self.receiveButton.backgroundColor = ._solitude
        }

        if UserDefaults.standard.bool(forKey: "invisible") {
            self.invisible = true
        } else {
            self.invisible = false
        }

        transfers = Transfer.calculateTransactions(transfers: transfers, orders: DataProvider.shared.orders).filter {($0.status == "paid" || $0.status == "Complete" || $0.status == "completed")}
        let months = Date().getLast12Month.1

        for month in months {
            let transaction = TransactionChartModel()
            transaction.date = month.prefix(7).description
            transactions.append(transaction)
        }

        for month in transactions {
            for transfer in transfers {
                if month.date == transfer.date?.prefix(7).description {
                    if transfer.source == "out" {
                        month.expenses +=  Float(transfer.quantity ?? "0.0")!
                    } else {
                        month.income +=  Float(transfer.quantity ?? "0.0")!
                    }
                }
            }
        }

        maxIncome = transactions.map({$0.income}).max()
        maxExpense = transactions.map({$0.expenses}).max()
        collectionView.reloadData()

        let tap = UITapGestureRecognizer(target: self, action: #selector(showWeb))

        websiteLinkLabel.addGestureRecognizer(tap)
        websiteLinkLabel.isUserInteractionEnabled = true
    }

    @objc fileprivate func showWeb() {
        if let url = URL(string: "https://sec.2local.io"),
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:])
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        let integerBalance = Int(Balance.monetaryValue(amount: "\(DataProvider.shared.user?.balance ?? 0.0)"))
        let stringBalance = "\(integerBalance)".convertToPriceType()
        if invisible {
            if self.balanceLabel.text !=  "******" {
                UIView.transition(with: self.balanceLabel, duration: 0.5, options: .transitionFlipFromTop, animations: {
                    self.balanceLabel.text = "******"
                }, completion: nil)

                UIView.transition(with: self.creditLabel, duration: 0.5, options: .transitionFlipFromTop, animations: {
                    self.creditLabel.text = "******"
                }, completion: nil)
            }
            invisibleBTN.setImage(#imageLiteral(resourceName: "eye1-selected"), for: .normal)
            UIView.animate(withDuration: 0.2) {
                self.view.layoutSubviews()
                self.view.layoutIfNeeded()
            }
        } else {
            if self.balanceLabel.text != "\(DataProvider.shared.user?.balance ?? 0.0)".convertToPriceType() {
                UIView.transition(with: self.balanceLabel, duration: 0.5, options: .transitionFlipFromTop, animations: {
                    self.balanceLabel.text = "******"// "\(Double(DataProvider.shared.user?.balance ?? "0.0")!)".convertToPriceType()
                }, completion: nil)

            }
            if self.creditLabel.text != "\(DataProvider.shared.exchangeRate?.defaultSym ?? "")\(stringBalance)" {
                UIView.transition(with: self.creditLabel, duration: 0.5, options: .transitionFlipFromTop, animations: {
                    self.creditLabel.text = "******"// "\(DataProvider.shared.exchangeRate?.defaultSym ?? "")\(stringBalance)"
                }, completion: nil)
            }

            UIView.animate(withDuration: 0.2) {
                self.view.layoutSubviews()
                self.view.layoutIfNeeded()
            }
        }
    }

    @IBAction func goToReceive(_ sender: Any) {
        KVNProgress.showError(withStatus: "Receive token is temporarily unavailable")
//        self.performSegue(withIdentifier: "goToReceive", sender: nil)
    }

    @IBAction func goToBuy(_ sender: Any) {
        KVNProgress.showError(withStatus: "Transaction is temporarily unavailable")
//        self.performSegue(withIdentifier: "goToBuy", sender: nil)
    }

    @IBAction func goToSend(_ sender: Any) {
        KVNProgress.showError(withStatus: "Send is temporarily unavailable")
//        self.performSegue(withIdentifier: "goToSend", sender: nil)
    }

    @IBAction func goToSettings(_ sender: Any) {
        self.parent?.parent?.performSegue(withIdentifier: "goToSettings", sender: nil)
    }

    @IBAction func goToNotification(_ sender: Any) {
        self.parent?.parent?.performSegue(withIdentifier: "goToNotification", sender: nil)
    }

    @IBAction func goToTransaction(_ sender: Any) {
        self.performSegue(withIdentifier: "goToTransactions", sender: nil)
    }

    @IBAction func invisibleAmounts(_ sender: Any) {
        let integerBalance = Int(Balance.monetaryValue(amount: "\(DataProvider.shared.user?.balance ?? 0.0)"))
        let stringBalance = "\(integerBalance)".convertToPriceType()
        if !invisible {
            UIView.transition(with: self.balanceLabel, duration: 0.5, options: .transitionFlipFromTop, animations: {
                self.balanceLabel.text = "******"
            }, completion: nil)

            UIView.transition(with: self.creditLabel, duration: 0.5, options: .transitionFlipFromTop, animations: {
                self.creditLabel.text = "******"
            }, completion: nil)
            invisibleBTN.setImage(#imageLiteral(resourceName: "eye1-selected"), for: .normal)
            UIView.animate(withDuration: 0.2) {
                self.view.layoutSubviews()
                self.view.layoutIfNeeded()
            }
        } else {
            if self.balanceLabel.text != "\(DataProvider.shared.user?.balance ?? 0.0)".convertToPriceType() {
                UIView.transition(with: self.balanceLabel, duration: 0.5, options: .transitionFlipFromTop, animations: {
                    self.balanceLabel.text = "******"// "\(Double(DataProvider.shared.user?.balance ?? "0.0")!)".convertToPriceType()
                }, completion: nil)

            }
            if self.creditLabel.text != "\(DataProvider.shared.exchangeRate?.defaultSym ?? "")\(stringBalance)" {
                UIView.transition(with: self.creditLabel, duration: 0.5, options: .transitionFlipFromTop, animations: {
                    self.creditLabel.text = "******"// "\(DataProvider.shared.exchangeRate?.defaultSym ?? "")\(stringBalance)"
                }, completion: nil)
            }
            invisibleBTN.setImage(#imageLiteral(resourceName: "eye1"), for: .normal)
            UIView.animate(withDuration: 0.2) {
                self.view.layoutSubviews()
                self.view.layoutIfNeeded()
            }
        }
        invisible = !invisible
        UserDefaults.standard.set(invisible, forKey: "invisible")
    }

}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "transactionCell", for: indexPath) as? TransactionChartCollectionViewCell else { return UITableViewCell() }
        cell.monthLabel.text = months[indexPath.row]
        let maxIncomeHeight = cell.barView.frame.height / 2
        let maxExpenseHeight = cell.barView.frame.height / 2
        let maxVal = max(self.maxIncome!, self.maxExpense!)

        UIView.animate(withDuration: 0, animations: {
            cell.incomeHeightConst.constant = 0
            cell.expenseHeightConst.constant = 0
            cell.barView.alpha = 0
            cell.indicatorView.alpha = 1
        }) { (_) in
            cell.barView.alpha = 1
            cell.indicatorView.alpha = 0
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
                cell.barView.alpha = 1
                cell.indicatorView.alpha = 0
                UIView.animate(withDuration: 1, delay: 0, options: [.curveEaseInOut], animations: {
                    // MARK: - Mock Data
                    //                    self.maxIncome = 20235.2
                    //                    self.maxExpense = 30235.2
                    //                    let maxVal = max(self.maxIncome!, self.maxExpense!)
                    //                    if indexPath.row == 11 {
                    //                        self.transactions[indexPath.row].income = 20235.2
                    //                    }
                    //                    if indexPath.row == 10 {
                    //                        self.transactions[indexPath.row].income = 13235.2
                    //                        self.transactions[indexPath.row].expenses = 30235.2
                    //                    }
                    //                    if indexPath.row == 4 {
                    //                        self.transactions[indexPath.row].income = 15000.0
                    //                        self.transactions[indexPath.row].expenses = 10000.0
                    //                    }
                    //                    if indexPath.row == 1 {
                    //                        self.transactions[indexPath.row].income = 3765.0
                    //                        self.transactions[indexPath.row].expenses = 20000.0
                    //                    }

                    cell.incomeHeightConst.constant = (CGFloat(self.transactions[indexPath.row].income) * maxIncomeHeight / CGFloat(maxVal))
                    cell.expenseHeightConst.constant =  (CGFloat(self.transactions[indexPath.row].expenses) * maxExpenseHeight / CGFloat(maxVal))
                    if (0...1).contains(cell.incomeHeightConst.constant) && (0...1).contains(cell.expenseHeightConst.constant ) || self.transfers.count == 0 {
                        cell.barView.alpha = 0
                        cell.indicatorView.alpha = 1
                    }
                    if (0...1).contains(cell.incomeHeightConst.constant) {
                        cell.incomeHeightConst.constant = 4
                    }
                    if (0...1).contains(cell.expenseHeightConst.constant) {
                        cell.expenseHeightConst.constant = 4
                    }
                    cell.barView.layoutIfNeeded()
                }) { (_) in

                }
            }
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 12, height: collectionView.frame.height)
    }

}

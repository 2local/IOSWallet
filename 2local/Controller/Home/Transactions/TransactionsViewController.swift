//
//  TransactionsViewController.swift
//  2local
//
//  Created by Hasan Sedaghat on 1/22/20.
//  Copyright © 2020 2local Inc. All rights reserved.
//

import UIKit
import Charts

class TransactionsViewController: BaseVC {
    
    //MARK: - outlets
    @IBOutlet var chartsSegmentedControl: SegmentedControl! {
        didSet {
            self.chartsSegmentedControl.setTitles([NSAttributedString(string: "Income", attributes: attributes),NSAttributedString(string: "Expenses", attributes: attributes)], selectedTitles: [NSAttributedString(string: "Income", attributes: selectedAttributes),NSAttributedString(string: "Expenses", attributes: selectedAttributes)])
            self.chartsSegmentedControl.delegate = self
            self.chartsSegmentedControl.selectionBoxStyle  = .default
            self.chartsSegmentedControl.selectionBoxColor = .clear
            self.chartsSegmentedControl.selectionIndicatorStyle = .bottom
            self.chartsSegmentedControl.selectionIndicatorColor = ._flamenco
            self.chartsSegmentedControl.selectionIndicatorHeight = 1
            self.chartsSegmentedControl.selectionIndicatorEdgeInsets = UIEdgeInsets(top: 0, left: 17, bottom: 0, right: 17)
        }
    }
    @IBOutlet var transactionSegmentedControl: SegmentedControl! {
        didSet {
            self.transactionSegmentedControl.setTitles(
                [NSAttributedString(string: "All", attributes: attributes)
                    ,NSAttributedString(string: "Purchase", attributes: attributes)
                    ,NSAttributedString(string: "Received", attributes: attributes)
                    ,NSAttributedString(string: "Sent", attributes: attributes)]
                , selectedTitles:
                [NSAttributedString(string: "All", attributes: selectedAttributes)
                    ,NSAttributedString(string: "Purchase", attributes: selectedAttributes)
                    ,NSAttributedString(string: "Received", attributes: selectedAttributes)
                    ,NSAttributedString(string: "Sent", attributes: selectedAttributes)])
            self.transactionSegmentedControl.delegate = self
            self.transactionSegmentedControl.selectionBoxStyle  = .default
            self.transactionSegmentedControl.selectionBoxColor = .clear
            self.transactionSegmentedControl.selectionIndicatorStyle = .bottom
            self.transactionSegmentedControl.selectionIndicatorColor = ._flamenco
            self.transactionSegmentedControl.selectionIndicatorHeight = 1
            self.transactionSegmentedControl.selectionIndicatorEdgeInsets = UIEdgeInsets(top: 0, left: 32, bottom: 0, right: 31)
        }
    }
    @IBOutlet var tableviewHeight: NSLayoutConstraint!
    @IBOutlet var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    @IBOutlet var scrollView: UIScrollView! {
        didSet {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 35, right: 0)
        }
        
    }
    @IBOutlet var lineChart: LineChartView! {
        didSet {
            lineChart.delegate = self
            lineChart.chartDescription?.text = ""
            lineChart.noDataText = "Data Not Available"
            lineChart.noDataFont = .TLFont(weight: .medium,
                                           size: 12)
            lineChart.noDataTextColor = .darkGray
            lineChart.animate(xAxisDuration: 1.5, yAxisDuration: 0)
            lineChart.xAxis.labelFont = .TLFont(weight: .regular,
                                                size: 10)
            lineChart.xAxis.labelTextColor = ._blueHaze
            lineChart.xAxis.axisLineColor = ._solitude
            lineChart.tintColor = .clear
            lineChart.borderColor = .clear
            lineChart.xAxis.axisLineWidth = 1.5
            lineChart.xAxis.axisLineWidth = 1.5
            lineChart.xAxis.gridColor = .clear
            lineChart.rightAxis.enabled = false
            lineChart.leftAxis.enabled = false
            lineChart.xAxis.labelPosition = .bottom
            lineChart.borderLineWidth = 1
            lineChart.doubleTapToZoomEnabled = false
            lineChart.pinchZoomEnabled = false
            lineChart.dragEnabled = false
            lineChart.dragXEnabled = false
            lineChart.dragYEnabled = false
            lineChart.autoScaleMinMaxEnabled = true
            lineChart.legend.enabled = false
            lineChart.xAxis.spaceMin = 1
            lineChart.xAxis.gridAntialiasEnabled = false
            lineChart.xAxis.axisRange = 1
            lineChart.xAxis.granularityEnabled = true
            lineChart.xAxis.granularity = 1
            lineChart.clipValuesToContentEnabled = false
        }
    }
    @IBOutlet weak var emptyBoxStack: UIStackView!

    //MARK: - properties
    var index = 0
    let attributes : [NSAttributedString.Key : Any] = [NSAttributedString.Key.foregroundColor : UIColor._logan, NSAttributedString.Key.font : UIFont.TLFont(weight: .regular, size: 13)]
    let selectedAttributes : [NSAttributedString.Key : Any] = [NSAttributedString.Key.foregroundColor : UIColor._flamenco,NSAttributedString.Key.font : UIFont.TLFont(weight: .medium, size: 13)]
    var transactions = [Transfer]()//DataProvider.shared.transfers
    var allTransactions = [Transfer]()
    private var wallet: Wallets?
    
    func initWith(_ transactions: [Transfer]) {
        self.transactions = transactions
    }
    
    //MARK: - view cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("transactions-> \(transactions.first?.date)")
        setupTableView()
        setupView()
    }
    
    //MARK: - function
    fileprivate func setupView() {
        setupLineChart(source: "in", firstSetup: true)
        emptyBoxStack.isHidden = true
        tableView.reloadData()
    }
    
    fileprivate func getTransaction() {
        allTransactions = Transfer.mapTransactions(transfers: transactions, orders: DataProvider.shared.orders)
        self.transactions = allTransactions
        tableView.reloadData()
    }
}

//MARK: - Segment
extension TransactionsViewController: SegmentedControlDelegate {
    
    func segmentedControl(_ segmentedControl: SegmentedControl, didSelectIndex selectedIndex: Int) {
        if segmentedControl == chartsSegmentedControl {
            if segmentedControl.selectedIndex != selectedIndex {
                if selectedIndex == 0 {
                    self.chartsSegmentedControl.selectionIndicatorEdgeInsets = UIEdgeInsets(top: 0, left: 17, bottom: 0, right: 17)
                    setupLineChart(source: "in", firstSetup: false)
                }
                else {
                    self.chartsSegmentedControl.selectionIndicatorEdgeInsets = UIEdgeInsets(top: 0, left: 11, bottom: 0, right: 11)
                    setupLineChart(source: "out", firstSetup: false)
                    
                }
            }
        } else {
            switch selectedIndex {
            case 0:
                self.transactionSegmentedControl.selectionIndicatorEdgeInsets = UIEdgeInsets(top: 0, left: 32, bottom: 0, right: 31)
                self.transactions = allTransactions
            case 1:
                self.transactionSegmentedControl.selectionIndicatorEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 11)
                self.transactions = []//allTransactions.filter{ $0.source == "Purchase"}
            case 2:
                self.transactionSegmentedControl.selectionIndicatorEdgeInsets = UIEdgeInsets(top: 0, left: 13, bottom: 0, right: 12)
                    self.transactions = allTransactions.filter{ $0.to == $0.wallet }//allTransactions.filter{ $0.source == "in" }
            case 3:
                self.transactionSegmentedControl.selectionIndicatorEdgeInsets = UIEdgeInsets(top: 0, left: 27, bottom: 0, right: 26)
                    self.transactions = allTransactions.filter{ $0.from == $0.wallet }//allTransactions.filter{ $0.source == "out" }
                
            default:
                break
            }
            if selectedIndex < self.index {
                tableView.reloadSections(IndexSet.init(integer: 0), with: .right)
            }
            else if selectedIndex > self.index {
                tableView.reloadSections(IndexSet.init(integer: 0), with: .left)
            }
            
            self.index = selectedIndex
            
            emptyBoxStack.isHidden = transactions.count != 0
        }
    }
}

//MARK: - Chart
extension TransactionsViewController: ChartViewDelegate {
    /// Charts
    func setupLineChart(source: String, firstSetup: Bool) {
        var chartDataEntry = [ChartDataEntry]()
        let lineChartData = LineChartData()
        var lineChartDataSet = LineChartDataSet()
        let weeks = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        
        let allTransactions = self.allTransactions.filter{ source == "in" ? ($0.source == source || $0.source == "Purchase" || $0.to == $0.wallet) : $0.source == source }.filter{($0.status == "paid" || $0.status == "Complete" || $0.status == "completed" || $0.from == $0.wallet) }
        var transfers = [Transfer]()
        let daysOfWeek = Date().getWeekDates()
        
        for day in daysOfWeek {
            var transfer = Transfer()
            transfer.date = day.description.prefix(10).description
            transfer.quantity = "0"
            transfers.append(transfer)
        }
        
        for transfer in transfers.enumerated() {
            for trans in allTransactions {
                if transfer.element.date == trans.date?.prefix(10).description {
                    let total = (Double(transfers[transfer.offset].quantity!)! + Double(trans.quantity!)!)
                    transfers[transfer.offset].quantity = "\(total)"
                }
            }
            let cost = Balance.monetaryValue(amount: transfers[transfer.offset].quantity)
            
            chartDataEntry.append(ChartDataEntry(x: Double(transfer.offset), y: cost,data: "$"))
        }
        
        lineChart.xAxis.axisMinimum = 0
        lineChart.xAxis.valueFormatter = IndexAxisValueFormatter.init(values: weeks)
        lineChartDataSet = LineChartDataSet(entries: chartDataEntry, label: "")
        lineChartDataSet.valueFont = .TLFont(weight: .medium,
                                             size: 10)
        lineChartDataSet.valueColors = [._blueHaze]
        lineChartDataSet.lineWidth = 1.5
        lineChartDataSet.circleRadius = 5
        lineChartDataSet.circleHoleRadius = 0
        lineChartDataSet.colors = [._lightSlateBlue]
        lineChartDataSet.circleColors = [._mediumSlateBlue]
        lineChartDataSet.circleHoleColor = ._mediumSlateBlue
        lineChartDataSet.highlightColor = .clear
        lineChartData.addDataSet(lineChartDataSet)
        if !firstSetup {
            let transition = CATransition()
            transition.type = CATransitionType.push
            transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
            
            if source == "out" {
                transition.subtype = CATransitionSubtype.fromRight
            }
            else {
                transition.subtype = CATransitionSubtype.fromLeft
            }
            transition.duration = 0.4
            
            self.lineChart.layer.add(transition, forKey: nil)
        }
        
        self.lineChart.data = lineChartData
        
    }
    
}

//MARK: - table view
extension TransactionsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setupTableView() {
        tableView.register(TransactionHistoryTableViewCell.self)
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableviewHeight.constant = CGFloat(transactions.count * 65)
        return self.transactions.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeue(TransactionHistoryTableViewCell.self)
        let data = transactions[indexPath.row]
        let wallet = Wallets(name: .TLocal,
                             balance: "",
                             address: "",
                             mnemonic: "",
                             displayName: "2Local")
        
        cell.fill(data, wallet: wallet)
        return cell
    }
}

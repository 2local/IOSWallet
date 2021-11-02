//
//  Transfer.swift
//  2Local
//
//  Created by Hasan Sedaghat on 9/4/19.
//  Copyright © 2019 Hasan Sedaghat. All rights reserved.
//

import UIKit

struct Transfer: Codable {
    var id: Int?
    var userId: Int?
    var date: String?
    var status: String?
    var quantity: String?
    var source: String?
    var wallet: String?
    var amount: String?
    var currency: String?
    var from: String?
    var to: String?
    
    static func mapTransactions(transfers: [Transfer], orders: [Order]) -> [Transfer] {
        var transactions = transfers
        let orders = orders
        for order in orders {
            var transfer = Transfer()
            transfer.date = order.date
            transfer.source = "Purchase"
            transfer.quantity = "\(order.tokens ?? 0)"
            transfer.amount = order.quantity
            transfer.currency = order.currency == "USD" ? "$" : "€"
            transfer.status = order.status
            transactions.append(transfer)
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        transactions = transactions.sorted(by: { dateFormatter.date(from:$0.date ?? "1999-01-01 00:00:00")!.compare(dateFormatter.date(from:$1.date ?? "1999-01-01 00:00:00")!) == .orderedDescending })
        return transactions
    }
    
    static func mapTransactions(_ histories: [TransactionHistoryModel], wallet: String, completion: @escaping (([Transfer]) -> Void)) {
        var transactions = [Transfer]()
        
        for history in histories {
            var transfer = Transfer()
            transfer.date = history.timeStamp
            transfer.from = history.from
            transfer.to = history.to
            transfer.quantity = history.value
            transfer.amount = history.gasPrice
            transfer.currency = "$"
            transfer.status = history.txreceiptStatus
            transfer.wallet = wallet
            transactions.append(transfer)
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        transactions = transactions.sorted(by: {($0.date ?? "0")!.compare($1.date ?? "0") == .orderedDescending })
//        transactions = transactions.sorted(by: {
//            dateFormatter.date(from: $0.date ?? "1999-01-01 00:00:00")!.compare(dateFormatter.date(from: $1.date ?? "1999-01-01 00:00:00")!) == .orderedDescending })
        completion(transactions)
    }
}

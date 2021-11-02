//
//  EtherTransactionHistoryModel.swift
//  2local
//
//  Created by Ebrahim Hosseini on 4/22/21.
//  Copyright © 2021 2local Inc. All rights reserved.
//

import Foundation


struct TransactionHistoryModel: Codable {
    var blockNumber: String?
    var timeStamp: String?
    var hash: String?
    var nonce: String?
    var blockHash: String?
    var transactionIndex: String?
    var from: String?
    var to: String?
    var value: String?
    var gas: String?
    var gasPrice: String?
    var isError: String?
    var txreceiptStatus: String?
    var input: String?
    var contractAddress: String?
    var cumulativeGasUsed: String?
    var gasUsed: String?
    var confirmations: String?
    
    enum CodingKeys: String, CodingKey {
        case blockNumber
        case timeStamp
        case hash
        case nonce
        case blockHash
        case transactionIndex
        case from
        case to
        case value
        case gas
        case gasPrice
        case isError
        case txreceiptStatus = "txreceipt_status"
        case input
        case contractAddress
        case cumulativeGasUsed
        case gasUsed
        case confirmations
    }
}

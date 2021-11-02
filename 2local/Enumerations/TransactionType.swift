//
//  TransactionType.swift
//  2local
//
//  Created by Ebrahim Hosseini on 4/22/21.
//  Copyright © 2021 2local Inc. All rights reserved.
//

import Foundation

enum TransactionType {
    case sent, received, purchase, pending, faild
    
    func icon() -> String {
        switch self {
        case .sent:
            return "sendTransaction"
        case .received:
            return "receiveTransaction"
        case .purchase:
            return "purchaseTransaction"
        case .faild:
            return "failTransaction"
        case .pending:
            return "pendingTransaction"
        }
    }
    
    func title() -> String {
        switch self {
        case .sent:
            return "Sent".localized
        case .received:
            return "Received".localized
        case .purchase:
            return "Purchase".localized
        case .faild:
            return "Failed".localized
        case .pending:
            return "Pending".localized
        }
    }
}

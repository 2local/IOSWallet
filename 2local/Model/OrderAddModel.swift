//
//  OrderAddModel.swift
//  2local
//
//  Created by Ebrahim Hosseini on 3/27/21.
//  Copyright © 2021 2local Inc. All rights reserved.
//

import Foundation

class AddOrderModel: Codable {
    var firstRecord: FirstRecord?
    var stellar: ExchangeRateSubject?
    var bitcoin: ExchangeRateSubject?
    var ethereum: ExchangeRateSubject?

    enum CodingKeys: String, CodingKey {
        case firstRecord = "0"
        case stellar, bitcoin, ethereum
    }
}

class FirstRecord: Codable {
    var eth: String?
    var stellar: String?
    var btc: String?
}

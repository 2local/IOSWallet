//
//  ExchangeRate.swift
//  2Local
//
//  Created by Hasan Sedaghat on 9/4/19.
//  Copyright © 2019 Hasan Sedaghat. All rights reserved.
//

import UIKit

class ExchangeRate: Codable {
    var bitcoin: ExchangeRateSubject?
    var ethereum: ExchangeRateSubject?
    var stellar: ExchangeRateSubject?

    var usd: String?
    var eur: String?
    var defaultExR: String?
    var defaultSym: String?

    enum CodingKeys: String, CodingKey {
        case bitcoin = "bitcoin"
        case ethereum = "ethereum"
        case stellar = "stellar"
        case usd = "USD"
        case eur = "EUR"
    }

}

class ExchangeRateSubject: Codable {
    var usd: Decimal?
    var eur: Decimal?
    var defaultExchangeRate: Decimal?
}

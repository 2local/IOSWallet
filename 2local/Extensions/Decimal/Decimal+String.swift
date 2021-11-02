//
//  Decimal+String.swift
//  2local
//
//  Created by Ebrahim Hosseini on 6/6/21.
//  Copyright © 2021 2local Inc. All rights reserved.
//

import Foundation

extension Decimal {
    var formattedAmount: String? {
        let formatter = NumberFormatter()
        formatter.generatesDecimalNumbers = true
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 3
        return formatter.string(from: self as NSDecimalNumber)
    }
}

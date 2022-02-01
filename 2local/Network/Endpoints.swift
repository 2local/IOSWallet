//
//  Endpoints.swift
//  2local
//
//  Created by Ebrahim Hosseini on 3/23/21.
//  Copyright © 2021 2local Inc. All rights reserved.
//

import Foundation

struct Endpoints {

    // MARK: - Auth
    static let login = "auth/login"
    static let register = "auth/register"
    static let validate = "auth/validate-twofa"

    // MARK: - Transfer
    static let makeTrust = "transfer/make-trust"
    static let getTransferOrderDetail = "transfer/get-transfer-order-details"
    static let getOrders = "order/get-orders"
    static let transferOrder = "transfer/transfer-order"

    // MARK: - Profile
    static let getProfile = "profile/get-profile"
    static let updateProfile = "profile/update-profile"

    // MARK: - Exchange
    static let getExchangeRate = "get-exchange-rates"
    static let L2LExchangeRate = "l2l-exchange-rate"

    // MARK: - Order
    static let addOrder = "order/add"
    static let mobile = "mollie"
    static let getBalance = "order/get-balance"

    // MARK: - Company
    static let createCompany = "create-company"
    static let getCompany = "get-companies"
}

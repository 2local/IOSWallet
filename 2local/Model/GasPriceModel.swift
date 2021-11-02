//
//  GasPriceModel.swift
//  2local
//
//  Created by Ebrahim Hosseini on 6/3/21.
//  Copyright © 2021 2local Inc. All rights reserved.
//

import Foundation

struct GasPriceModel: Codable {
    let lastBlock: String
    let safeGasPrice: String
    let proposeGasPrice: String
    let fastGasPrice: String
    
    enum CodingKeys: String, CodingKey {
        case lastBlock = "LastBlock"
        case safeGasPrice = "SafeGasPrice"
        case proposeGasPrice = "ProposeGasPrice"
        case fastGasPrice = "FastGasPrice"
    }
    
    init(safeGasPrice: String, proposeGasPrice: String, fastGasPrice: String, lastBlock: String) {
        self.safeGasPrice = safeGasPrice
        self.proposeGasPrice = proposeGasPrice
        self.fastGasPrice = fastGasPrice
        self.lastBlock = lastBlock
    }
}

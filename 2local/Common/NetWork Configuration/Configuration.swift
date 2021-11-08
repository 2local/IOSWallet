//
//  URLConfiguration.swift
//  2local
//
//  Created by Ebrahim Hosseini on 3/23/21.
//  Copyright © 2021 2local Inc. All rights reserved.
//

import Foundation


class Configuration {
    
    static let shared = Configuration()
    
    var googleApiKey: String
    var baseURL: String
    var ethscanUrl: String
    var ethscanToken: String
    var infuraUrl: String
    var infuraToken: String
    var bitrueUrl: String
    var bscScanUrlTestnet: String
    var bscScanUrl: String
    var apiKey: String
    var bscScanToken: String
    var issuer: String
    var issuingKeys: String
    var sourceKey: String
    var publicKey: String
    var stellarWalletNumber: String
    var etheriumWalletNumber: String
    var bitcoinWalletNumber: String
    var tokenContractAddress: String
    var password: String
    var aesMode: String
    
    
    init() {
        if let dictionary = Bundle.main.infoDictionary,
           let configuration = dictionary["Configuration"] as? String {
            let path = Bundle.main.path(forResource: "Configuration", ofType: "plist")
            let config = NSDictionary(contentsOfFile: path!)
            for (key, value) in config! {
                if let key = key as? String,
                   let value = value as? [String: Any] {
                    if key == configuration {
                        googleApiKey = value["googleApiKey"]  as? String ?? ""
                        baseURL = value["baseURL"]  as? String ?? ""
                        ethscanUrl = value["ethscanUrl"]  as? String ?? ""
                        ethscanToken = value["ethscanToken"]  as? String ?? ""
                        infuraUrl = value["infuraUrl"]  as? String ?? ""
                        infuraToken = value["infuraToken"]  as? String ?? ""
                        bitrueUrl = value["bitrueUrl"]  as? String ?? ""
                        bscScanUrlTestnet = value["bscScanUrlTestnet"]  as? String ?? ""
                        bscScanUrl = value["bscScanUrl"]  as? String ?? ""
                        apiKey = value["apiKey"]  as? String ?? ""
                        bscScanToken = value["bscScanToken"] as? String ?? ""
                        issuer = value["issuer"] as? String ?? ""
                        issuingKeys = value["issuingKeys"] as? String ?? ""
                        sourceKey = value["sourceKey"] as? String ?? ""
                        publicKey = value["publicKey"] as? String ?? ""
                        stellarWalletNumber = value["stellarWalletNumber"] as? String ?? ""
                        etheriumWalletNumber = value["etheriumWalletNumber"] as? String ?? ""
                        bitcoinWalletNumber = value["bitcoinWalletNumber"] as? String ?? ""
                        tokenContractAddress = value["tokenContractAddress"] as? String ?? ""
                        password = value["password"] as? String ?? ""
                        aesMode = value["aesMode"] as? String ?? ""
                        
                        return
                    }
                }
            }
        }
        fatalError("Error: Configuration file doesn't exist in project directory, please include it to be able to use this class")
    }
}



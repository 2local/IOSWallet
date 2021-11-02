//
//  ResultData.swift
//  2Local
//
//  Created by Hasan Sedaghat on 9/1/19.
//  Copyright © 2019 Hasan Sedaghat. All rights reserved.
//

import UIKit

class User: Codable {
    var id: Int?
    var name: String?
    var userType: String?
    var email: String?
    var twofaStatus: Bool?
    var apiToken: String?
    var affiliateCode: String?
    var affiliatedStatus: Int?
    var locked: Int?
    var status: Bool?
    var accessToken: String?
    var tokenType: String?
    var mobileNumber: String?
    var mobileVerificationStatus: String?
    var firstName: String?
    var lastName: String?
    var country: String?
    var countryCode: String?
    var city: String?
    var state: String?
    var address: String?
    var image: String?
    var businessName: String?
    var notes: String?
    var webSite: String?
    var hope: String?
    var balance: Double = 0
    
    enum CodingKeys : String , CodingKey {
        case id = "id"
        case name = "name"
        case userType = "user_type"
        case email = "email"
        case twofaStatus = "twofa_status"
        case apiToken = "api_token"
        case affiliateCode = "affiliate_code"
        case affiliatedStatus = "affilated_status"
        case locked = "locked"
        case status = "status"
        case accessToken = "access_token"
        case tokenType = "token_type"
        case mobileNumber = "mobile_number"
        case mobileVerificationStatus = "mobile_verification_status"
        case firstName = "first_name"
        case lastName = "last_name"
        case country = "country"
        case countryCode = "country_code"
        case city = "city"
        case state = "state"
        case address = "address"
        case image = "image"
        case businessName = "business_name"
        case notes = "notes"
        case webSite = "website"
        case hope = "hope"
    }
    
//    required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        
//        let stringBalance = try? container.decode(String.self, forKey: .balance)
//        let intBalance = try? container.decode(Int.self, forKey: .balance)
//        self.balance = stringBalance ?? "\(intBalance ?? -1)"
//    }
}

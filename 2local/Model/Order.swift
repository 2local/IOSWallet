//
//  Order.swift
//  2Local
//
//  Created by Hasan Sedaghat on 9/4/19.
//  Copyright © 2019 Hasan Sedaghat. All rights reserved.
//

import UIKit

class Order: Codable {
    var id:Int?
    var userId:Int?
    var paymentId:String?
    var paymentType:String?
    var quantity:String?
    var requestor:String?
    var status:String?
    var date:String?
    var tokens:Float?
    var currency : String?
    
    enum CodingKeys : String , CodingKey {
        case id = "id"
        case userId = "user_id"
        case paymentId = "payment_id"
        case paymentType = "payment_type"
        case quantity = "quantity"
        case requestor = "requestor"
        case status = "status"
        case date = "date"
        case tokens = "ltwol_tokens"
        case currency = "currency"
    }
}

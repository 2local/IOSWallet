//
//  Place.swift
//  2local
//
//  Created by Hasan Sedaghat on 1/26/20.
//  Copyright © 2020 2local Inc. All rights reserved.
//

import UIKit

struct Place: Codable {
    var companies: [Companies]?
}
    
struct Companies: Codable {
    var id: Int?
    var name: String?
    var tel: String?
    var address: String?
    var lat: String?
    var lng: String?
    var websiteURL: String?
    var status: Int?
    var reserve: String?
    var apiId: Int?
    var location: String?
    var cci: String?
    var sustainable: String?
    var representative: String?
    var isSync: Int?
    var createdAt: String?
    var updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "company_name"
        case websiteURL = "website_url"
        case lat = "latitude"
        case lng = "longitude"
        case status = "status"
        case reserve = "reserve"
        case address = "address"
        case apiId = "api_id"
        case location = "location"
        case cci = "cci"
        case sustainable = "sustainable"
        case representative = "representative"
        case isSync = "is_sync"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}


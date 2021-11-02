//
//  LocaleDataManageable.swift
//  2local
//
//  Created by Ebrahim Hosseini on 9/22/21.
//  Copyright © 2021 2local Inc. All rights reserved.
//

import Foundation

protocol LocaleDataManageable {
    var token: String { get }
    var user: User? { get }
    var password: String? { get }
    var isBiometricEnable: Bool { get }
    
    func setToken(_ token: String)
    func setUser(_ user: User?)
    func setPassword(_ password: String?)
    func setBiometric(_ enabled: Bool)
}
 
extension LocaleDataManageable {
    
    func getTokenHeader() -> [String : String]? {
        return ["Authorization": getTokenField()]
    }
    
    func getTokenField() -> String {
        return "Bearer " + token
    }
    
    var hasPassword: Bool {
        return password != nil
    }
    
    var hasToken: Bool {
        return token != ""
    }
}


//
//  LocalDataManager.swift
//  2local
//
//  Created by Ebrahim Hosseini on 9/22/21.
//  Copyright © 2021 2local Inc. All rights reserved.
//

import Foundation

class LocalDataManager: NSObject, LocaleDataManageable {

    // MARK: - Singletone
    static let shared = LocalDataManager()

    // MARK: - Saved data
    @Storage(key: "token", defaultValue: "")
    internal var token: String

    @Storage(key: "user", defaultValue: nil)
    internal var user: User?

    @Storage(key: "password", defaultValue: nil)
    internal var password: String?

    @Storage(key: "biometric", defaultValue: true)
    internal var isBiometricEnable: Bool

    func setToken(_ token: String) {
        self.token = token
    }

    func setUser(_ user: User?) {
        self.user = user
    }

    func setPassword(_ password: String?) {
        self.password = password
    }

    func setBiometric(_ enabled: Bool) {
        self.isBiometricEnable = enabled
    }

    let guestToken = UUID().uuidString
}

//
//  FirebaseRemoteConfig.swift
//  2local
//
//  Created by Ibrahim Hosseini on 11/26/21.
//  Copyright © 2021 2local Inc. All rights reserved.
//

import Foundation
import Firebase
import FirebaseRemoteConfig

class FBRemoteConfig {
    static let shared = FBRemoteConfig()
    
    var loadingDoneCallback: (() -> Void)?
    var fetchComplete = false
    
    private init() {
        loadDefaultValues()
        fetchCloudValue()
    }
    
    
    func loadDefaultValues() {
        let defaultValue: [String: Any?] = [
            ValueKey.anouncement_msg.rawValue: "",
            ValueKey.show_anouncement.rawValue: false,
            ValueKey.maintenance_msg.rawValue: "",
            ValueKey.maintenance_mode.rawValue: false
        ]
        remoteConfig.setDefaults(defaultValue as? [String: NSObject])
    }
    
    private func activateDebugMode() {
        let settings = RemoteConfigSettings()
        // WARNING: Don't actually do this in production!
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
    }
    
    func fetchCloudValue(){
        #if DEBUG
        activateDebugMode()
        #endif
        
        remoteConfig.fetch { [weak self] _, error in
            guard let self = self else { return }
            if let error = error  {
                print("Uh-oh. Got an error fetching remote values \(error)")
                return
            }
            remoteConfig.activate { [weak self] _, _ in
                guard let self = self else { return }
                self.fetchComplete = true
                DispatchQueue.main.async {
                    self.loadingDoneCallback?()
                }
            }
        }
    }
    
    func bool(forKey key: ValueKey) -> Bool {
        remoteConfig[key.rawValue].boolValue
    }
    
    func string(forKey key: ValueKey) -> String {
        remoteConfig[key.rawValue].stringValue ?? ""
    }
}

//enum value keys
enum ValueKey: String {
    case anouncement_msg
    case show_anouncement
    case maintenance_msg
    case maintenance_mode
}

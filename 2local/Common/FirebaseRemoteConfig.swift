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
    
    private init() {
        loadDefaultValues()
        fetchCloudValue()
    }
    
    
    func loadDefaultValues() {
        let defaultValue: [String: Any?] = [
            ValueKey.anouncement_msg.rawValue: "Due to a security breach we are replacing wallets, in the process balances will appear 0.",
            ValueKey.show_anouncement.rawValue: false,
            ValueKey.maintenance_msg.rawValue: "Due to a security breach we are replacing wallets, in the process balances will appear 0.",
            ValueKey.maintenance_mode.rawValue: true
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
        
        activateDebugMode()
        
        remoteConfig.fetch { [weak self] _, error in
            guard let self = self else { return }
            if let error = error  {
                print("Uh-oh. Got an error fetching remote values \(error)")
                
                return
            }
            
            remoteConfig.activate { [weak self] _, _ in
                guard let self = self else { return }
                print("Retrieved values from the cloud!")
                let msg = self.displayNewValues(.maintenance_msg)
                print("maintenance_msg", msg)
            }
        }
    }
    
    func displayNewValues(_ key: ValueKey) -> String {
        let newLabelText = remoteConfig.configValue(forKey: key.rawValue).stringValue ?? ""
        return newLabelText
    }
    
    func bool(forKey key: ValueKey) -> Bool {
        remoteConfig[key.rawValue].boolValue
    }

    func string(forKey key: ValueKey) -> String {
      remoteConfig[key.rawValue].stringValue ?? ""
    }
}

//enum RemoteConfigs
enum ValueKey: String {
    case anouncement_msg
    case show_anouncement
    case maintenance_msg
    case maintenance_mode
}

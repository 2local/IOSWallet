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
      ValueKey.announcementMessage.rawValue: "",
      ValueKey.showAnnouncement.rawValue: false,
      ValueKey.maintenanceMessage.rawValue: "",
      ValueKey.maintenanceMode.rawValue: false,
      ValueKey.enableInstructionWhenNoWalletAddedAndBalanceIsZero.rawValue: false,
      ValueKey.enableInstructionWhenNoWalletAddedAndBalanceIsZeroMessage.rawValue: ""
    ]
    remoteConfig.setDefaults(defaultValue as? [String: NSObject])
  }
  
  private func activateDebugMode() {
    let settings = RemoteConfigSettings()
    
    // WARNING: Don't actually do this in production!
    settings.minimumFetchInterval = 0
    remoteConfig.configSettings = settings
  }
  
  // get data from cloud
  func fetchCloudValue(){
    
    
#if DEBUG
    //this function only works in Debug mode
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
  case announcementMessage = "anouncement_msg"
  case showAnnouncement = "show_anouncement"
  case maintenanceMessage = "maintenance_msg"
  case maintenanceMode = "maintenance_mode"
  case enableInstructionWhenNoWalletAddedAndBalanceIsZero = "enable_instruction_when_no_wallet_added_and_balance_is_zero"
  case enableInstructionWhenNoWalletAddedAndBalanceIsZeroMessage = "enable_instruction_when_no_wallet_added_and_balance_is_zero_msg"
}

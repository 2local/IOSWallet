//
//  LAContext+Extension.swift
//  2local
//
//  Created by Ebrahim Hosseini on 9/21/21.
//  Copyright © 2021 2local Inc. All rights reserved.
//

import Foundation
import LocalAuthentication

enum BiometricType: String, CaseIterable {
    case none
    case touchID
    case faceID
}

extension LAContext {
    
    var biometricType: BiometricType {
        var error: NSError?
        
        guard self.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            return .none
        }
        
        switch self.biometryType {
            case .none:
                return .none
            case .touchID:
                return .touchID
            case .faceID:
                return .faceID
            @unknown default:
                #warning("Handle new Biometric type")
        }
        
        return  self.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) ? .touchID : .none
    }
}

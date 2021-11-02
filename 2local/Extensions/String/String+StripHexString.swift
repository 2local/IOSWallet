//
//  String+StripHexString.swift
//  2local
//
//  Created by Ebrahim Hosseini on 7/17/21.
//  Copyright © 2021 2local Inc. All rights reserved.
//

import Foundation

extension String {
    var stripHexPrefix: String {
        if self.hasPrefix("0x") {
            let indexStart = self.index(self.startIndex, offsetBy: 2)
            return String(self[indexStart...])
        }
        return self
    }
}

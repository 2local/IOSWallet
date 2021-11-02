//
//  String+Validation.swift
//  2local
//
//  Created by Ebrahim Hosseini on 9/15/21.
//  Copyright © 2021 2local Inc. All rights reserved.
//

import Foundation

extension String {
    ///Mac address validator
    func isValidPrivatekey() -> Bool {
        let macRegEx = "^0[x][0-9A-Za-z]{64}"

        let macPred = NSPredicate(format:"SELF MATCHES %@", macRegEx)
        return macPred.evaluate(with: self)
    }
}

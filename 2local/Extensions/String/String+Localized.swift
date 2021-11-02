//
//  String+Localized.swift
//  2local
//
//  Created by Ebrahim Hosseini on 3/23/21.
//  Copyright © 2021 2local Inc. All rights reserved.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    func localizedWithFormat(values: CVarArg ...) -> String {
        return String(format: NSLocalizedString(self, comment: ""), arguments: values)
    }
}

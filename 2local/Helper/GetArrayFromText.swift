//
//  GetArrayFromText.swift
//  2local
//
//  Created by Ebrahim Hosseini on 4/12/21.
//  Copyright © 2021 2local Inc. All rights reserved.
//

import Foundation

func getArrayFrom(_ text: String, seprateBy: SepratType = .space) -> [String] {
    return text.components(separatedBy: seprateBy.rawValue)
}

enum SepratType: String {
    case space = " "
    case exclamationMark = "!"
    case kama = ","
}

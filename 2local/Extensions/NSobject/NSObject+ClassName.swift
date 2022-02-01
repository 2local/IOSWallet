//
//  NSObject+ClassName.swift
//  2local
//
//  Created by Ebrahim Hosseini on 4/6/21.
//  Copyright © 2021 2local Inc. All rights reserved.
//
import Foundation

extension NSObject {
    var className: String {
        return String(describing: type(of: self))
    }

    class var className: String {
        return String(describing: self)
    }
}

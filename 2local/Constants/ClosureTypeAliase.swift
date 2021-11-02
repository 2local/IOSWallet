//
//  ClosureTypeAliase.swift
//  2local
//
//  Created by Ebrahim Hosseini on 3/28/21.
//  Copyright © 2021 2local Inc. All rights reserved.
//

import Foundation

public typealias SimpleAction = (() -> ())?
public typealias DataAction<T> = ((T?) -> ())?


//
//  UITableView+Register.swift
//  2local
//
//  Created by Ebrahim Hosseini on 3/23/21.
//  Copyright © 2021 2local Inc. All rights reserved.
//

import UIKit

extension UITableView {
    func register<T: UITableViewCell>(_ cell: T.Type) {
        self.register(UINib(nibName: String(describing: cell), bundle: nil), forCellReuseIdentifier: String(describing: cell))
    }
}


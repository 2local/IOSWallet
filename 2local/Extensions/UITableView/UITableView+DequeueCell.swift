//
//  UITableView+DequeueCell.swift
//  2local
//
//  Created by Ebrahim Hosseini on 3/23/21.
//  Copyright © 2021 2local Inc. All rights reserved.
//

import UIKit

extension UITableView {
    func dequeue<T: UITableViewCell>(_ cell: T.Type) -> T {
        self.dequeueReusableCell(withIdentifier: String(describing: cell)) as! T
    }
}

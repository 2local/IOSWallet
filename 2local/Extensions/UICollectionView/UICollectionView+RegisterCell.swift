//
//  UICollectionView+RegisterCell.swift
//  2local
//
//  Created by Ebrahim Hosseini on 3/23/21.
//  Copyright © 2021 2local Inc. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    /// Register cells with nib file
    func register<T: UICollectionViewCell>(_ cell: T.Type) {
        self.register(UINib(nibName: String(describing: cell), bundle: nil),
                      forCellWithReuseIdentifier: String(describing: cell))
    }
    
    func registerReusableView<T: UICollectionReusableView>(_ cell: T.Type, ofKind: String) {
        self.register(cell,
                      forSupplementaryViewOfKind: ofKind,
                      withReuseIdentifier: String(describing: cell))
    }
}


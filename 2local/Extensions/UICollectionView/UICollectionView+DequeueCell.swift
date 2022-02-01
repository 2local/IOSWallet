//
//  UICollectionView+DequeueCell.swift
//  2local
//
//  Created by Ebrahim Hosseini on 3/23/21.
//  Copyright © 2021 2local Inc. All rights reserved.
//

import UIKit

extension UICollectionView {
  func dequeue<T: UICollectionViewCell>(_ cell: T.Type, indexPath: IndexPath) -> T {
    (self.dequeueReusableCell(withReuseIdentifier: String(describing: cell),
                              for: indexPath) as? T)!
  }
  func dequeueReusableView<T: UICollectionReusableView>(_ cell: T.Type,
                                                        ofKind kind: String,
                                                        indexPath: IndexPath) -> T {
    (self.dequeueReusableSupplementaryView(ofKind: kind,
                                           withReuseIdentifier: String(describing: cell),
                                           for: indexPath) as? T)!
  }
}

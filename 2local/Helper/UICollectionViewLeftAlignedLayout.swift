//
//  UICollectionViewLeftAlignedLayout.swift
//  2local
//
//  Created by Ebrahim Hosseini on 4/13/21.
//  Copyright © 2021 2local Inc. All rights reserved.
//

import UIKit

final class UICollectionViewLeftAlignedLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var newAttributesArray = [UICollectionViewLayoutAttributes]()
        let superAttributesArray = super.layoutAttributesForElements(in: rect)!
        for (index, attributes) in superAttributesArray.enumerated() {
            if index == 0 || superAttributesArray[index - 1].frame.origin.y != attributes.frame.origin.y {
                attributes.frame.origin.x = sectionInset.left
            } else {
                let previousAttributes = superAttributesArray[index - 1]
                let previousFrameRight = previousAttributes.frame.origin.x + previousAttributes.frame.width
                attributes.frame.origin.x = previousFrameRight + minimumInteritemSpacing
            }
            newAttributesArray.append(attributes)
        }
        return newAttributesArray
    }
}

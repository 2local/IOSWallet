//
//  UIColor+GenerateImage.swift
//  2local
//
//  Created by Ebrahim Hosseini on 4/10/21.
//  Copyright © 2021 2local Inc. All rights reserved.
//
import UIKit

extension UIColor {

    /// Converts this `UIColor` instance to a 1x1 `UIImage` instance and returns it.
    ///
    /// - Returns: `self` as a 1x1 `UIImage`.
    func as1ptImage() -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 0.5))
        setFill()
        UIGraphicsGetCurrentContext()?.fill(CGRect(x: 0, y: 0, width: 1, height: 0.5))
        let image = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
        return image
    }
}

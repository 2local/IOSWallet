//
//  UIImage+TintColor.swift
//  2local
//
//  Created by Ebrahim Hosseini on 4/1/21.
//  Copyright © 2021 2local Inc. All rights reserved.
//

import UIKit

extension UIImage {
    /**
     Creates a new image with the passed in color.
     - Parameter color: The UIColor to create the image from.
     - Returns: A UIImage that is the color passed in.
     */
    open func tint(with color: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }

        context.scaleBy(x: 1.0, y: -1.0)
        context.translateBy(x: 0.0, y: -size.height)

        context.setBlendMode(.multiply)

        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        context.clip(to: rect, mask: cgImage!)
        color.setFill()
        context.fill(rect)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image?.withRenderingMode(.alwaysOriginal)
    }

}

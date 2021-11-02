//
//  UIFont.swift
//  2local
//
//  Created by Ebrahim Hosseini on 3/23/21.
//  Copyright © 2021 2local Inc. All rights reserved.
//

import UIKit

extension UIFont {
    class func TLFont(weight: TLFonts = .regular, size fontSize: CGFloat = 16.0, style: TextStyle = .body) -> UIFont {
        let customFont = UIFont(name: weight.rawValue, size: fontSize)!
        return UIFontMetrics(forTextStyle: style).scaledFont(for: customFont)
    }
}

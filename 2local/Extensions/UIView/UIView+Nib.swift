//
//  UIView+Nib.swift
//  2local
//
//  Created by Ebrahim Hosseini on 4/10/21.
//  Copyright © 2021 2local Inc. All rights reserved.
//

import UIKit

extension UIView {
    
    class func fromNib(nibNameOrNil: String? = nil) -> Self {
        return fromNib(nibNameOrNil: nibNameOrNil, type: self)
    }
    
    class func fromNib<T: UIView>(nibNameOrNil: String? = nil, type: T.Type) -> T {
        let view: T? = fromNib(nibNameOrNil: nibNameOrNil, type: T.self)
        return view!
    }
    
    class func fromNib<T: UIView>(nibNameOrNil: String? = nil, type: T.Type) -> T? {
        var view: T?
        let name: String
        if let nibName = nibNameOrNil {
            name = nibName
        } else {
            // Most nibs are demangled by practice, if not, just declare string explicitly
            name = String(describing: T.self)
        }
        
        let nibViews = Bundle.main.loadNibNamed(name, owner: nil, options: nil)
        
        nibViews?.forEach({ (nibView) in
            if let tog = nibView as? T {
                view = tog
            }
        })
        
        return view
    }
    
}


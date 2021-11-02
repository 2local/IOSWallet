//
//  UIStoryboard+Instantiation.swift
//  2local
//
//  Created by Ebrahim Hosseini on 3/23/21.
//  Copyright © 2021 2local Inc. All rights reserved.
//

import UIKit

extension UIStoryboard {
    
    class var main: UIStoryboard {
        return self.init(name: "Main", bundle: nil)
    }
    
    class var wallet: UIStoryboard {
        return self.init(name: "Wallet", bundle: nil)
    }
    
    class var marketplace: UIStoryboard {
        return self.init(name: "Marketplace", bundle: nil)
    }
    
    class var home: UIStoryboard {
        return self.init(name: "Home", bundle: nil)
    }
    
    class var intro: UIStoryboard {
        return self.init(name: "Intro", bundle: nil)
    }
    
    class var scan: UIStoryboard {
        return self.init(name: "Scan", bundle: nil)
    }
    
    class var authentication: UIStoryboard {
        return self.init(name: "Authentication", bundle: nil)
    }
    
    class var splash: UIStoryboard {
        return self.init(name: "Splash", bundle: nil)
    }
    
    class var transaction: UIStoryboard {
        return self.init(name: "Transaction", bundle: nil)
    }
    
    class var notification: UIStoryboard {
        return self.init(name: "Notification", bundle: nil)
    }
    
    class var settings: UIStoryboard {
        return self.init(name: "Settings", bundle: nil)
    }
    
}

extension UIStoryboard {
    func instantiate<T: UIViewController>(viewController: T.Type) -> T {
        return self.instantiateViewController(withIdentifier: String(describing: T.self)) as! T
    }
}


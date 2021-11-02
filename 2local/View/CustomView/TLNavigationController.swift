//
//  TLNavigationController.swift
//  2local
//
//  Created by Ebrahim Hosseini on 4/10/21.
//  Copyright © 2021 2local Inc. All rights reserved.
//

import UIKit

class TLNavigationController: UINavigationController {
    
    /// Indicates if a UIViewController is currently being pushed onto this navigation controller
    private var duringPushAnimation = false
    
    var isTransparentStyled: Bool = true {
        didSet {
            setupStyle()
        }
    }
    
    var hasShadow: Bool = false {
        didSet{
            setupStyle()
        }
    }
    
    //MARK: - view cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        self.interactivePopGestureRecognizer?.delegate = self
        self.navigationBar.prefersLargeTitles = false
        
        self.navigationBar.backIndicatorImage = UIImage(named: "back")
        self.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "back")
        self.navigationBar.titleTextAttributes = [.font: UIFont.TLFont(weight: .medium, size: 16), .foregroundColor: UIColor._606060]
        self.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor._606060, NSAttributedString.Key.font: UIFont.TLFont(weight: .medium, size: 24)]
        self.navigationBar.tintColor = ._606060
        setupStyle()
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        duringPushAnimation = true
        super.pushViewController(viewController, animated: animated)
    }
    
    deinit {
        delegate = nil
        interactivePopGestureRecognizer?.delegate = nil
    }
    
    func setupStyle() {
        if isTransparentStyled {
            self.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.navigationBar.shadowImage = UIImage()
            
            self.navigationBar.barTintColor = .white
            self.navigationBar.isTranslucent = true
        } else {
            self.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.navigationBar.shadowImage = hasShadow ? UIColor._606060.withAlphaComponent(0.2).as1ptImage() : UIImage()
            
            self.navigationBar.barTintColor = .white
            self.navigationBar.isTranslucent = false
        }
    }
    
    func isTransparentNavigationBarWithShadow(_ isTrue: Bool = true){
        let NavBarBackGround: UIImage = isTrue ? UIImage() : UIColor._606060.withAlphaComponent(0.2).as1ptImage()
        self.navigationBar.setBackgroundImage(NavBarBackGround, for: .default)
        self.navigationBar.isTranslucent = isTrue
        self.navigationBar.backgroundColor = isTrue ? .clear : .white
    }
    
    func removeShadowColor(_ isTrue: Bool = true) {
        self.navigationBar.setBackgroundImage(UIColor.white.as1ptImage(), for: .default)
        self.navigationBar.shadowImage = isTrue ? UIImage() : UIColor.white.withAlphaComponent(0.2).as1ptImage()
        self.navigationBar.barTintColor = isTrue ? .clear : .white
    }
    
}

// MARK: - UINavigationControllerDelegate
extension TLNavigationController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        (navigationController as? TLNavigationController)?.duringPushAnimation = false
    }
    
}

// MARK: - UIGestureRecognizerDelegate
extension TLNavigationController: UIGestureRecognizerDelegate {

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard gestureRecognizer == interactivePopGestureRecognizer else {
            return true
        }
        return viewControllers.count > 1 && self.duringPushAnimation == false
    }
    
}


//
//  BaseVC.swift
//  2local
//
//  Created by Ebrahim Hosseini on 4/3/21.
//  Copyright © 2021 2local Inc. All rights reserved.
//

import UIKit

public let userDefaults = UserDefaults.standard

class BaseVC: UIViewController {

    //MARK: - Outlets
    
    
    //MARK: - Properties
    
    
    //MARK: - View cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: - Functions
    fileprivate func setupView() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .done, target: nil, action: nil)
    }
    
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        return nil
    }
    
    func tapToDismiss() {
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endEditing)))
    }
    
    @objc public func endEditing() {
        self.view.endEditing(true)
    }
    
    public func showLoginView( _ viewController: UIViewController) {
        let vc = UIStoryboard.authentication.instantiate(viewController: LoginViewController.self)
        vc.modalPresentationStyle = .fullScreen
        viewController.present(vc, animated: true)
    }
    
    func setNavigation(title: String? = nil, largTitle: Bool = false, foregroundColor: UIColor = UIColor._606060) {
        
        //        if title != nil {
        
        
        navigationItem.title = title
        let fontSize: CGFloat = largTitle ? 24 : 16
        
        let attributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key.foregroundColor: foregroundColor,
                                                          NSAttributedString.Key.font: UIFont.TLFont(weight: .medium, size: fontSize)]
        
        self.navigationController?.navigationBar.prefersLargeTitles = largTitle
        self.navigationController?.navigationBar.largeTitleTextAttributes = attributes
        self.navigationController?.navigationBar.titleTextAttributes = attributes
        
        //        } else {
        //
        //            let header = UIImageView(frame: CGRect(x: 0, y: 0, width: (1060.0 / 472.0 ) * 44 , height: 44))
        //            header.contentMode = .scaleAspectFit
        //            header.image = UIImage(named: "logo")!
        //            let w = header.widthAnchor.constraint(equalToConstant: header.frame.width)
        //            w.priority = UILayoutPriority.defaultHigh
        //            w.isActive = true
        //            let h = header.heightAnchor.constraint(equalToConstant: header.frame.height)
        //            h.priority = UILayoutPriority.defaultHigh
        //            h.isActive = true
        //            navigationItem.titleView = header
        //        }
    }
    
    public func createButtonItems(_ icon: String, colorIcon: UIColor? = ._606060, action: Selector) -> UIBarButtonItem {
                
        let button = UIButton(type: .custom)
        if let colorIcon = colorIcon {
            button.setImage(UIImage(named: icon)?
                                .tint(with: colorIcon), for: [.normal])
        } else {
            button.setImage(UIImage(named: icon), for: [.normal])
        }
        button.addTarget(self, action: action, for: .touchUpInside)
        let buttonIcon = UIBarButtonItem(customView: button)
        
        buttonIcon.customView?.frame = CGRect(x: 0, y: 0, width: 30, height: 22)
        let wTicket = buttonIcon.customView?.widthAnchor.constraint(equalToConstant: 30)
        wTicket?.priority = UILayoutPriority.defaultHigh
        wTicket?.isActive = true
        let hTicket = buttonIcon.customView?.heightAnchor.constraint(equalToConstant: 25)
        hTicket?.priority = UILayoutPriority.defaultHigh
        hTicket?.isActive = true
        
        return buttonIcon
    }
    
    func getTextAttributeSpace(_ text: String) ->  NSMutableAttributedString {
        
        let items: [String] = getArrayFrom(text)
        var mnemonic = ""
        items.forEach { (item) in
            mnemonic += item + "    "
        }
        
        let attributedString = NSMutableAttributedString(string: mnemonic)

        // *** Create instance of `NSMutableParagraphStyle`
        let paragraphStyle = NSMutableParagraphStyle()

        // *** set LineSpacing property in points ***
        paragraphStyle.lineSpacing = 12

        // *** Apply attribute to string ***
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range: NSMakeRange(0, attributedString.length))

        return attributedString
    }
    
    func getETHWalletAddress() -> String {
        return Web3Service.currentAddress ?? ""
    }

}

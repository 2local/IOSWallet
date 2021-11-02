//
//  MainViewController.swift
//  2local
//
//  Created by Hasan Sedaghat on 12/30/19.
//  Copyright © 2019 2local Inc. All rights reserved.
//

import UIKit
import KVNProgress

class MainViewController: BaseVC, MarketInfoDelegate {
    
    //MARK: - Outlets
    @IBOutlet var tabBarView: TLTabBarView!
    @IBOutlet var tabBarIMG: UIImageView!
    
    @IBOutlet var tab1: UIButton!
    @IBOutlet var tab1IMG: UIImageView!
    @IBOutlet var tab1Label: UILabel!
    
    @IBOutlet var tab2: UIButton!
    @IBOutlet var tab2IMG: UIImageView!
    @IBOutlet var tab2Label: UILabel!
    
    @IBOutlet var tab3: UIButton!
    @IBOutlet var tab3IMG: UIImageView!
    @IBOutlet var tab3Label: UILabel!
    
    @IBOutlet var tab4: UIButton!
    @IBOutlet var tab4IMG: UIImageView!
    @IBOutlet var tab4Label: UILabel!
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var tabBarHeight: NSLayoutConstraint!
    
    @IBOutlet var marketInfoView: MarketInfoView!
    @IBOutlet var marketInfoHeight: NSLayoutConstraint!
    
    //MARK: - properties
    var marketVC : MarketViewController?
    var bottomPadding = 0
    
    //MARK: - cycle view
    fileprivate func hideTabbarTitle() {
        self.tab1Label.isHidden = true
        self.tab2Label.isHidden = true
        self.tab3Label.isHidden = true
        self.tab4Label.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.parent?.view.setShadow(color: UIColor._002CA4, opacity: 0.1, offset: CGSize(width: 0, height: -3), radius: 10)
        hideTabbarTitle()

        self.tab1Label.isHidden = false
        self.tab1Label.textColor = ._flamenco
        self.tab1IMG.image = UIImage(named: "home")?.tint(with: ._flamenco)
        
        tab1.addTarget(self, action: #selector(tabAction(sender:)), for: .touchUpInside)
        tab3.addTarget(self, action: #selector(tabAction(sender:)), for: .touchUpInside)
        tab4.addTarget(self, action: #selector(tabAction(sender:)), for: .touchUpInside)
        tabBarView.setShadow(color: ._000372, opacity: 0.7, offset: CGSize(width: 1, height: 1), radius: 10)
        tabBarIMG.isHidden = true
        
        marketVC = self.children.last?.children.first as? MarketViewController
        marketVC?.delegate = self
        self.marketInfoHeight.constant = 0
        self.marketInfoView.closeBTN.addTarget(self, action: #selector(closeMarketInfoView), for: .touchUpInside)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.marketVC?.setPadding(inset: self.bottomPadding)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.adjustTabBarHeight()
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @IBAction func home(_ sender: Any) {
        self.scrollView.setContentOffset(CGPoint.zero, animated: true)
    }
    
    @IBAction func market(_ sender: Any) {
        self.scrollView.setContentOffset(CGPoint(x: Int(self.view.frame.width), y: 0), animated: true)
    }
    
    @IBAction func scan(_ sender: Any) {
        self.performSegue(withIdentifier: "goToScan", sender: nil)
    }
    
    @IBAction func walletTapped(_ sender: Any) {
        self.scrollView.setContentOffset(CGPoint(x: Int(self.view.frame.width) * 2, y: 0), animated: true)
    }
    
    @objc func tabAction(sender:UIButton) {
            hideTabbarTitle()
        if sender == tab1 {
            UIView.transition(with: tabBarView, duration: 0.2, options: [.transitionCrossDissolve], animations: {
                self.tab1Label.textColor = ._flamenco
                self.tab1IMG.image = UIImage(named: "home")?.tint(with: ._flamenco)
                self.tab1Label.isHidden = false
                
                self.tab3Label.textColor = ._topaz
                self.tab3IMG.image = UIImage(named: "market")?.tint(with: ._topaz)

                self.tab4Label.textColor = ._topaz
                self.tab4IMG.image = UIImage(named: "wallet")?.tint(with: ._topaz)
                
            }, completion: nil)
        }
        if sender == tab3 {
            UIView.transition(with: tabBarView, duration: 0.2, options: [.transitionCrossDissolve], animations: {
                self.tab1Label.textColor = ._topaz
                self.tab1IMG.image = UIImage(named: "home")?.tint(with: ._topaz)
                
                self.tab3Label.textColor = ._flamenco
                self.tab3IMG.image = UIImage(named: "market")?.tint(with: ._flamenco)
                self.tab3Label.isHidden = false
                
                self.tab4Label.textColor = ._topaz
                self.tab4IMG.image = UIImage(named: "wallet")?.tint(with: ._topaz)
                
            }, completion: nil)
        }
        if sender == tab4 {
            UIView.transition(with: tabBarView, duration: 0.2, options: [.transitionCrossDissolve], animations: {
                self.tab1Label.textColor = ._topaz
                self.tab1IMG.image = UIImage(named: "home")?.tint(with: ._topaz)
                
                self.tab3Label.textColor = ._topaz
                self.tab3IMG.image = UIImage(named: "market")?.tint(with: ._topaz)
                
                self.tab4Label.textColor = ._flamenco
                self.tab4IMG.image = UIImage(named: "wallet")?.tint(with: ._flamenco)
                self.tab4Label.isHidden = false
            }, completion: nil)
        }
    }
    
    func adjustTabBarHeight() {
        if UIDevice.current.modelName == "iPhone X" || UIDevice.current.modelName == "iPhone XS" || UIDevice.current.modelName == "iPhone XS Max" || UIDevice.current.modelName == "iPhone XR" || UIDevice.current.modelName == "iPhone 11" || UIDevice.current.modelName == "iPhone 11 Pro" || UIDevice.current.modelName == "iPhone 11 Pro Max" || UIDevice.current.modelName == "Simulator" || UIDevice.current.modelName == "iPhone 12" || UIDevice.current.modelName == "iPhone 12 Pro" || UIDevice.current.modelName == "iPhone 12 Pro Max" || UIDevice.current.modelName == "iPhone 12 Mini" {
            DispatchQueue.main.async {
                self.tabBarHeight.constant = 100
                self.bottomPadding = Int(68)
            }
        } else {
            DispatchQueue.main.async {
                self.tabBarHeight.constant = 73
                self.bottomPadding = Int(self.tabBarHeight.constant)
            }
        }
        
    }
    
    func marketDidSelected(id: Int) {
        let marketInfoViewHeight : CGFloat = 200.0
        let mapPadding = 170
        UIView.animate(withDuration: 0.2) {
            self.marketInfoView.nameLabel.text = DataProvider.shared.places[id].name
            self.marketInfoView.websiteLabel.text = DataProvider.shared.places[id].websiteURL
            //self.marketInfoView.callLabel.text = DataProvider.shared.places[id].tel
            //self.marketInfoView.addressLabel.text = DataProvider.shared.places[id].address
            
        }
        //self.marketInfoView.callNumber = DataProvider.shared.places[id].tel ?? "+1"
        self.marketInfoView.lat = Double(DataProvider.shared.places[id].lat ?? "0.0")!
        self.marketInfoView.lng = Double(DataProvider.shared.places[id].lng ?? "0.0")!
        //self.marketInfoView.callBTN.addTarget(self, action: #selector(callMarket), for: .touchUpInside)
        self.marketInfoView.directionBTN.addTarget(self, action: #selector(directionMarket), for: .touchUpInside)
        
        if marketInfoHeight.constant == 0 {
//            if self.marketInfoView.superview == nil {
//                self.marketInfoView.frame.origin = CGPoint(x: 0, y: self.view.frame.height - marketInfoViewHeight)
//                self.view.addSubview(self.marketInfoView)
//            }
            if UIDevice.current.modelName == "iPhone X" || UIDevice.current.modelName == "iPhone XS" || UIDevice.current.modelName == "iPhone XS Max" || UIDevice.current.modelName == "iPhone XR" || UIDevice.current.modelName == "iPhone 11" || UIDevice.current.modelName == "iPhone 11 Pro" || UIDevice.current.modelName == "iPhone 11 Pro Max" || UIDevice.current.modelName == "Simulator"  {
                
                UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: [.curveEaseOut], animations: {
                    self.marketInfoHeight.constant = marketInfoViewHeight
                    self.marketVC?.setPadding(inset: mapPadding)
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }
            else {
                UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: [.curveEaseOut], animations: {
                    self.marketInfoHeight.constant = marketInfoViewHeight
                    self.marketVC?.setPadding(inset: mapPadding + 40)
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }
        }
    }
    
    @objc func callMarket() {
        let numbers = self.marketInfoView.callNumber.split(separator: ",")
        if let number = (numbers.randomElement()?.description)?.replacingOccurrences(of: " ", with: "") {
            if let url = URL(string: "tel://\(number)"), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                
            }
        }
    }
    
    @objc func directionMarket() {
        
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
            if let url = "comgooglemaps://?saddr=&daddr=\(self.marketInfoView.lat)),\(self.marketInfoView.lng))&directionsmode=driving".getCleanedURL() {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            else {
                KVNProgress.showError(withStatus: "The coordinator is not valid")
            }
        }
        else if let url = "http://maps.apple.com/maps?saddr=\(self.marketInfoView.lat),\(self.marketInfoView.lng)".getCleanedURL(), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        else {
            KVNProgress.showError(withStatus: "You don't have any map in your device")
        }
        
    }
    
    @objc func closeMarketInfoView() {
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [.curveEaseIn], animations: {
            
            self.marketInfoHeight.constant = 0
            self.view.layoutIfNeeded()
            self.marketVC?.setPadding(inset: self.bottomPadding)
            self.marketVC?.clearMarkers()
        }, completion: nil)
    }
}

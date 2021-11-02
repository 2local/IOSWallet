//
//  TLButton.swift
//  2local
//
//  Created by Hasan Sedaghat on 12/30/19.
//  Copyright © 2019 2local Inc. All rights reserved.
//

import UIKit

class TLButton: UIButton {
    @IBInspectable var pressedColor: UIColor?
    var currentBackgroundColor:UIColor?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        currentBackgroundColor = self.backgroundColor
        
        //let tapGesture = UITapGestureRecognizer(target: self,action:  #selector (tap))
        self.addTarget(self, action: #selector(tap(sender:)), for: .touchUpInside)
        let longGesture = UILongPressGestureRecognizer(target: self,action:  #selector(long))
        //tapGesture.numberOfTapsRequired = 1
        //self.addGestureRecognizer(tapGesture)
        self.addGestureRecognizer(longGesture)
        self.setTitleColor(self.titleColor(for: .normal), for: [.normal,.highlighted,.selected])
    }
    
    
    @objc func long(sender: UILongPressGestureRecognizer){
        self.setTitleColor(self.titleColor(for: .normal), for: [.normal,.highlighted])
        if sender.state == .began {
            UIView.animate(withDuration: 0.1) {
                self.backgroundColor = self.pressedColor
            }
        }
        else if sender.state == .cancelled || sender.state == .ended || sender.state == .failed {
            UIView.animate(withDuration: 0.1) {
                self.backgroundColor = self.currentBackgroundColor
            }
        }
    }
    
    
    
    @objc func tap(sender:UIButton){
        UIView.animate(withDuration: 0.15, animations: {
            self.backgroundColor = self.pressedColor
        }) { (finish) in
            UIView.animate(withDuration: 0.1) {
                self.backgroundColor = self.currentBackgroundColor
            }
        }
    }
    
}


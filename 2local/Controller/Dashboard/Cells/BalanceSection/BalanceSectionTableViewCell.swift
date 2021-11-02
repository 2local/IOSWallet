//
//  BalanceSectionTableViewCell.swift
//  2local
//
//  Created by Ibrahim Hosseini on 10/10/21.
//  Copyright © 2021 2local Inc. All rights reserved.
//

import UIKit

class BalanceSectionTableViewCell: UITableViewCell {
    
    //MARK: - outlets
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var hiddenButton: UIButton!
    
    //MARK: - properties
    var invisible = false
    private var totalfiatWithSymbol: String = "$0"
    var invisibleCallback: DataAction<Bool> = nil
    
    //MARK: - life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        balanceLabel.text = ""
        balanceLabel.font = .TLFont(weight: .medium, size: 46, style: .body)
        
        hiddenButton.setTitle("", for: .normal)
        hiddenButton.setImage(UIImage(named: "eyeFill")?.tint(with: ._707070), for: .normal)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    //MARK: - functions
    func fill(_ balance: String, invisible: Bool) {
        self.totalfiatWithSymbol = balance
        self.invisible = invisible
        invisibleAction()
    }
    
    fileprivate func invisibleAction() {
        if invisible {
            UIView.transition(with: self.balanceLabel, duration: 0.5, options: .transitionFlipFromTop, animations: {
                self.balanceLabel.text = "******"
            }, completion: nil)
            hiddenButton.setImage(UIImage(named: "eye1-selected")?.tint(with: ._707070), for: .normal)
            UIView.animate(withDuration: 0.2) {
                self.contentView.layoutSubviews()
                self.contentView.layoutIfNeeded()
            }
        } else {
            if self.balanceLabel.text != totalfiatWithSymbol {
                UIView.transition(with: self.balanceLabel, duration: 0.5, options: .transitionFlipFromTop, animations: { [self] in
                    balanceLabel.text = totalfiatWithSymbol
                }, completion: nil)
            }
            hiddenButton.setImage(UIImage(named: "eyeFill")?.tint(with: ._707070), for: .normal)
            UIView.animate(withDuration: 0.2) {
                self.contentView.layoutSubviews()
                self.contentView.layoutIfNeeded()
            }
        }
    }
    
    //MARK: - actions
    @IBAction func invisibleAmounts(_ sender: Any) {
        invisible.toggle()
        invisibleAction()
        invisibleCallback?(self.invisible)
        UserDefaults.standard.set(invisible, forKey: "invisible")
    }
    
    
}

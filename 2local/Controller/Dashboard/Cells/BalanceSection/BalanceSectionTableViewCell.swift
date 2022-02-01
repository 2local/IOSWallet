//
//  BalanceSectionTableViewCell.swift
//  2local
//
//  Created by Ibrahim Hosseini on 10/10/21.
//  Copyright © 2021 2local Inc. All rights reserved.
//

import UIKit

class BalanceSectionTableViewCell: UITableViewCell {

    // MARK: - outlets
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var tokenCountLabel: UILabel!
    @IBOutlet weak var hiddenButton: UIButton!

    // MARK: - properties
    var invisible = false
    private var totalfiatWithSymbol: String = "$0"
    private var totalTokenWithSymbol: String = "0 2LC"
    var invisibleCallback: DataAction<Bool> = nil
    let hideImage = UIImage(named: "eyeHide")?.tint(with: .color707070)
    let showImage = UIImage(named: "eyeFill")?.tint(with: .color707070)

    // MARK: - life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        balanceLabel.text = ""
        balanceLabel.font = .TLFont(weight: .regular, size: 22, style: .body)

        tokenCountLabel.text = ""
        tokenCountLabel.font = .TLFont(weight: .medium, size: 40, style: .body)
        tokenCountLabel.adjustsFontSizeToFitWidth = true

        hiddenButton.setTitle("", for: .normal)
        hiddenButton.setImage(hideImage, for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // MARK: - functions
    func fill(_ balance: String, tokenCount: String, invisible: Bool) {
        self.totalfiatWithSymbol = balance
        totalTokenWithSymbol = tokenCount
        self.invisible = invisible
        invisibleAction()
    }

    fileprivate func invisibleAction() {
        if invisible {
            UIView.transition(with: self.balanceLabel, duration: 0.5, options: .transitionFlipFromTop, animations: {
                self.balanceLabel.text = "******"
                self.tokenCountLabel.text = "******"
            }, completion: nil)
            hiddenButton.setImage(showImage, for: .normal)
            UIView.animate(withDuration: 0.2) {
                self.contentView.layoutSubviews()
                self.contentView.layoutIfNeeded()
            }
        } else {
            if self.balanceLabel.text != totalfiatWithSymbol {
                UIView.transition(with: self.balanceLabel, duration: 0.5, options: .transitionFlipFromTop, animations: { [self] in
                    balanceLabel.text = totalfiatWithSymbol
                    tokenCountLabel.text = totalTokenWithSymbol
                }, completion: nil)
            }
            hiddenButton.setImage(hideImage, for: .normal)
            UIView.animate(withDuration: 0.2) {
                self.contentView.layoutSubviews()
                self.contentView.layoutIfNeeded()
            }
        }
    }

    // MARK: - actions
    @IBAction func invisibleAmounts(_ sender: Any) {
        invisible.toggle()
        invisibleAction()
        invisibleCallback?(self.invisible)
        UserDefaults.standard.set(invisible, forKey: "invisible")
    }
}

//
//  AddNewWalletCollectionViewCell.swift
//  2local
//
//  Created by Ebrahim Hosseini on 3/28/21.
//  Copyright © 2021 2local Inc. All rights reserved.
//

import UIKit

class AddNewWalletCollectionViewCell: UICollectionViewCell {

    // MARK: - Outlets
    @IBOutlet weak var placeholderImageView: UIImageView!
    @IBOutlet weak var addNewWalletButton: UIButton!
    @IBOutlet weak var itemWidth: NSLayoutConstraint!

    // MARK: - properties
    var addNewWalletButtonCallback: SimpleAction = nil

    // MARK: - cycle
    override func awakeFromNib() {
        super.awakeFromNib()

        placeholderImageView.image = UIImage(named: "placeholder")
        placeholderImageView.contentMode = .scaleToFill
        placeholderImageView.setCornerRadius(10)

        addNewWalletButton.setImage(UIImage(named: "add"), for: .normal)
        addNewWalletButton.setTitle("Add new wallet", for: .normal)
        addNewWalletButton.titleLabel?.font = .TLFont(weight: .medium, size: 16, style: .body)
        addNewWalletButton.titleLabel?.textColor = .color9796AE
        addNewWalletButton.titleEdgeInsets.left = 8

        itemWidth.constant = UIScreen.main.bounds.width - 24
    }

    // MARK: - functions
    @IBAction func addNewWalletTapped(_ sender: UIButton) {
        addNewWalletButtonCallback?()
    }

}

//
//  SeedPhraseCollectionViewCell.swift
//  2local
//
//  Created by Ebrahim Hosseini on 4/10/21.
//  Copyright © 2021 2local Inc. All rights reserved.
//

import UIKit

class SeedPhraseCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet weak var containerView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()

        containerView.setBorderWith(.e0e0eb, width: 1)
        containerView.setCornerRadius(8)
    }

    func fill(_ title: String) {
        self.titleLabel.text = title
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
    }

}

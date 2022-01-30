//
//  CustomNibView.swift
//  2local
//
//  Created by Ebrahim Hosseini on 4/6/21.
//  Copyright © 2021 2local Inc. All rights reserved.
//

import UIKit

class CustomNibView: UIView {
    let nibName = "ReusableCustomView"
    var contentView: UIView?
    override init(frame: CGRect) {
        super.init(frame: frame)
        guard let view = loadViewFromNib() else { return }
        view.frame = frame
        self.frame = frame
        self.addSubview(view)
        contentView = view
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
        contentView = view
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView?.frame = self.bounds
    }

    private func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: self.className, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
}

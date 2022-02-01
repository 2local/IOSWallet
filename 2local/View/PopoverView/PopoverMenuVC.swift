//
//  PopoverMenuVC.swift
//  2local
//
//  Created by Ebrahim Hosseini on 4/5/21.
//  Copyright © 2021 2local Inc. All rights reserved.
//

import UIKit

enum WalletAction {
    case rename, remove
}

class PopoverMenuVC: BaseVC {

    // MARK: - Outlets
    @IBOutlet weak var renameButton: UIButton!
    @IBOutlet weak var removeButton: UIButton!

    // MARK: - Properties
    var delegate: PopupActions?
    var enableRemoveButton = true

    // MARK: - View cycle
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

    // MARK: - Functions
    fileprivate func setupView() {
        ([renameButton, removeButton]).forEach { (button) in
            button?.titleEdgeInsets.left = 8
        }
        removeButton.isEnabled = enableRemoveButton
        let color = enableRemoveButton ? UIColor.bittersweet : UIColor.FE6C6C
        removeButton.setTitleColor(color, for: .normal)
    }

    @IBAction func renameTapped(_ sender: UIButton) {
        if let delegate = self.delegate {
            dismiss(animated: false) {
                delegate.popoverRenameWallet()
            }
        }
    }

    @IBAction func removeTapped(_ sender: UIButton) {
        if let delegate = self.delegate {
            dismiss(animated: false) {
                delegate.popoverRemoveWallet()
            }
        }
    }

}

//
//  SuccessfulCreateWalletVC.swift
//  2local
//
//  Created by Ebrahim Hosseini on 4/9/21.
//  Copyright © 2021 2local Inc. All rights reserved.
//

import UIKit
import KVNProgress

class SuccessfulCreateWalletVC: BaseVC {

    // MARK: - Outlets
    @IBOutlet weak var donButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!

    // MARK: - Properties
    private var isRecovered = false

    func initWith(_ isRecovered: Bool) {
        self.isRecovered = isRecovered
    }

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
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    // MARK: - Functions
    fileprivate func setupView() {
        donButton.setCornerRadius(8)

        descriptionLabel.text = isRecovered ? "Your wallet successfully has been recovered" : "Your Ethereum wallet successfully has been created"
    }

    // MARK: - Actions
    @IBAction func doneTapped(_ sender: UIButton) {
        DispatchQueue.main.async {
            KVNProgress.show()
        }
        if let navigation = navigationController {
            DispatchQueue.main.async {
                KVNProgress.dismiss {
                    navigation.dismiss(animated: true)
                }
            }
        }
    }
}

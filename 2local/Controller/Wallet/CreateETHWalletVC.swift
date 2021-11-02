//
//  CreateETHWalletVC.swift
//  2local
//
//  Created by Ebrahim Hosseini on 4/9/21.
//  Copyright © 2021 2local Inc. All rights reserved.
//

import UIKit
import web3swift

class CreateETHWalletVC: BaseVC {
    
    //MARK: - Outlets
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var checkBoxButton: UIButton!
    @IBOutlet weak var agreementLabel: UILabel!
    @IBOutlet weak var mnemonicLabel: UILabel!
    @IBOutlet weak var mnemonicContainerView: UIView!
    
    //MARK: - Properties
    private var walletName: Coins?
    private var agreement: Bool = false
    private var items: [String] = []
    
    var wallet: Wallet!
    var mnemonics: String?
    
    func initWith(walletName: Coins) {
        self.walletName = walletName
    }
    
    //MARK: - View cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        createETHCoin()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: - Functions
    fileprivate func setupView() {
        if let walletName = walletName?.rawValue {
            setNavigation(title: "Create \(walletName) wallet")
        }
        
        continueButton.setCornerRadius(8)
        agreementLabel.isUserInteractionEnabled = true
        agreementLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(agreementCheckTapped(_:))))
        
        updateAgreementStatus()
        
        mnemonicLabel.text = ""
        mnemonicContainerView.setBorderWith(._E0E0EB, width: 1)
        mnemonicContainerView.setCornerRadius(8)
    }
    
    fileprivate func updateAgreementStatus() {
        checkBoxButton.setCornerRadius(4)
        if agreement {
            checkBoxButton.setImage(UIImage(named: "check")?.tint(with: .white), for: .normal)
            checkBoxButton.setBorderWith(.clear, width: 1)
            checkBoxButton.backgroundColor = ._EF8749
            agreementLabel.textColor = ._303030
            continueButton.backgroundColor = ._EF8749
            continueButton.isEnabled = true
        } else {
            checkBoxButton.setImage(nil, for: .normal)
            checkBoxButton.setBorderWith(._EBEBEB, width: 1)
            checkBoxButton.backgroundColor = .clear
            agreementLabel.textColor = ._707070
            DispatchQueue.main.async {
                self.continueButton.backgroundColor = UIColor._EF8749.withAlphaComponent(0.5)
            }
            continueButton.isEnabled = false
        }
    }
    
    fileprivate func createETHCoin() {
        self.mnemonics = try! BIP39.generateMnemonics(bitsOfEntropy: 128)!
        
        guard let mnemonics = self.mnemonics else { return }
        mnemonicLabel.attributedText = getTextAttributeSpace(mnemonics)
        items = getArrayFrom(mnemonics)
        self.wallet = Wallet.init(type: .BIP39(mnemonic: mnemonics))
    }
    
    //MARK: - Actions
    @objc @IBAction func agreementCheckTapped(_ sender: UIButton) {
        agreement.toggle()
        updateAgreementStatus()
    }
    
    @IBAction func continueTapped(_ sender: UIButton) {
        let vc = UIStoryboard.wallet.instantiate(viewController: VerifyRecoveryWalletVC.self)
        if (self.items.count > 0), let walletName = self.walletName, let mnemonics = self.mnemonics {
            vc.initWith(walletName: walletName, items: items, mnemonics: mnemonics)
            if let navigation = navigationController {
                navigation.pushViewController(vc, animated: true)
            }
        }
    }
}

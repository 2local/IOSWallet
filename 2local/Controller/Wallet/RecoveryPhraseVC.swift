//
//  RecoveryPhraseVC.swift
//  2local
//
//  Created by Ebrahim Hosseini on 4/9/21.
//  Copyright © 2021 2local Inc. All rights reserved.
//

import UIKit
import web3swift
import KVNProgress

class RecoveryPhraseVC: BaseVC {
    
    //MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var recoveryTextView: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var dividerView: UIView!
    @IBOutlet weak var scanButton: UIButton!
    
    
    //MARK: - Properties
    private var placeholderText = "Recovery words"
    private var placeholderColor = UIColor._blueHaze
    private var coin: Coins?
    
    func initWith(_ coin: Coins) {
        self.coin = coin
    }
    
    //MARK: - View cycle
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
    
    //MARK: - Functions
    fileprivate func setupView() {
        let title = coin == Coins.TLocal ? "Enter Private Key" : "Enter Recovery Phrase"
        
        placeholderText = coin == Coins.TLocal ? "Private key" : "Recovery words"
        
        titleLabel.text = coin == Coins.TLocal ? "Please enter your private key to recover your wallet" : "Please enter your phrase to recover your wallet"
        
        setNavigation(title: title)
        
        submitButton.setCornerRadius(8)
        
        tapToDismiss()
        
        dividerView.backgroundColor = ._E0E0EB
        
        errorLabel.isHidden = true
        clearButton.isHidden = true
        
        scanButton.isHidden = false
        scanButton.setTitle("", for: .normal)
        scanButton.setImage(UIImage(named: "scan-1")?.tint(with: ._707070), for: .normal)
        
        DispatchQueue.main.async {
            self.recoveryTextView.textContainerInset.right = 45
            self.recoveryTextView.text = self.placeholderText
            self.recoveryTextView.textColor = self.placeholderColor
            self.recoveryTextView.delegate = self
            self.recoveryTextView.selectedTextRange = self.recoveryTextView.textRange(from: self.recoveryTextView.beginningOfDocument, to: self.recoveryTextView.beginningOfDocument)
        }
        
    }
    
    fileprivate func SaveWallet() {
        switch coin {
        case .Ethereum:
            createETHWallet()
        case .TLocal:
            import2LC()
        case .Binance, .Bitcoin, .Stellar:
            break
        default:
            break
        }
    }
    
    fileprivate func import2LC() {
        guard let privateKey = self.recoveryTextView.text else { return }
        let cleanPK = privateKey.trimmingCharacters(in: .whitespaces)
        do {
            try Web3Service.shared.import2LCBy(privateKey: cleanPK) { [weak self] walletAddress in
                guard let self = self, let walletAddress = walletAddress else { return }
                
                userDefaults.setValue(cleanPK, forKey: UserDefaultsKey.TLCWallet.rawValue)
                
                do {
                    ///get the 2LC token balance
                    let tlcBalance = try Web3Service.shared.getBEP20TokenBalance(walletAddress: walletAddress)
                    
                    ///add the 2LC token in list
                    let tlcWallet = Wallets(name: .TLocal, balance: tlcBalance, address: walletAddress, mnemonic: nil, displayName: Coins.TLocal.rawValue)
                    
                    DataProvider.shared.wallets.append(tlcWallet)
                    self.goToSuccessView()
                    
                } catch {
                    print("2LC balance error")
                }
                
                do {
                    ///get the BNB token balance
                    let bnbBalance = try Web3Service.shared.getBNBBalance(walletAddress: walletAddress)
                    
                    ///add the BNB token in list
                    let bnbWallet = Wallets(name: .Binance, balance: bnbBalance, address: walletAddress, mnemonic: nil, displayName: Coins.Binance.rawValue)
                    DataProvider.shared.wallets.append(bnbWallet)
                } catch {
                    print("BNB balance error")
                }
                
            }
        } catch {
            print("Import 2lc token error")
        }
    }
    
    fileprivate func goToSuccessView() {
        NotificationCenter.default.post(name: Notification.Name.wallet, object: nil)
        let vc = UIStoryboard.wallet.instantiate(viewController: SuccessfulCreateWalletVC.self)
        vc.initWith(true)
        if let navigation = self.navigationController {
            navigation.pushViewController(vc, animated: true)
        }
    }
    
    fileprivate func createETHWallet() {
        guard let mnemonics = self.recoveryTextView.text else { return }
        
        userDefaults.setValue(mnemonics, forKey: UserDefaultsKey.ETHWallet.rawValue)

        guard let address = Web3Service.currentAddress else {
            errorLabel.isHidden = false
            userDefaults.removeObject(forKey: UserDefaultsKey.ETHWallet.rawValue)
            return
        }

        
        Web3Service.getETHBalance { (balance) in
            let ethWallet = Wallets(name: .Ethereum, balance: balance, address: address, mnemonic: mnemonics, displayName: Coins.Ethereum.rawValue)
            DataProvider.shared.wallets.append(ethWallet)
            NotificationCenter.default.post(name: Notification.Name.wallet, object: nil)
            userDefaults.setValue(Coins.Ethereum.rawValue, forKey: Coins.Ethereum.rawValue)
        }
        
        let vc = UIStoryboard.wallet.instantiate(viewController: SuccessfulCreateWalletVC.self)
        vc.initWith(true)
        if let navigation = navigationController {
            navigation.pushViewController(vc, animated: true)
        }
    }
    
    
    //MARK: - Actions
    @IBAction func continueTapped(_ sender: UIButton) {
        SaveWallet()
    }
    
    @IBAction func scanTapped(_ sender: UIButton) {
        let vc = UIStoryboard.scan.instantiate(viewController: ScanViewController.self)
        vc.modalPresentationStyle = .fullScreen
        vc.scannerDelegate = self
        vc.initWith(false)
        present(vc, animated: true)
    }
    
    @IBAction func clearTapped(_ sender: UIButton) {
        recoveryTextView.text = ""
        clearButton.isHidden = true
        errorLabel.isHidden = true
        
        scanButton.isHidden = false
        
        DispatchQueue.main.async {
            self.recoveryTextView.text = self.placeholderText
            self.recoveryTextView.textColor = self.placeholderColor
            self.recoveryTextView.becomeFirstResponder()
            self.recoveryTextView.selectedTextRange = self.recoveryTextView.textRange(from: self.recoveryTextView.beginningOfDocument, to: self.recoveryTextView.beginningOfDocument)
        }
    }

}

//MARK: - Text view delegate
extension RecoveryPhraseVC: UITextViewDelegate {
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        if textView.textColor == placeholderColor {
//            textView.text = nil
//            textView.textColor = ._202020
//            clearButton.isHidden = false
//        }
//    }
//
//    func textViewDidEndEditing(_ textView: UITextView) {
//        if textView.text.isEmpty {
//            textView.text = placeholderText
//            textView.textColor = placeholderColor
//            clearButton.isHidden = true
//        }
//    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        // Combine the textView text and the replacement text to
        // create the updated text string
        let currentText:String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)

        // If updated text view will be empty, add the placeholder
        // and set the cursor to the beginning of the text view
        if updatedText.isEmpty {

            textView.text = placeholderText
            textView.textColor = placeholderColor
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)

            clearButton.isHidden = true
            scanButton.isHidden = false
        }

        // Else if the text view's placeholder is showing and the
        // length of the replacement string is greater than 0, set
        // the text color to black then set its text to the
        // replacement string
         else if textView.textColor == placeholderColor && !text.isEmpty {
            textView.textColor = ._202020
            textView.text = text
            
            clearButton.isHidden = false
            scanButton.isHidden = true
        }

        // For every other case, the text should change with the usual
        // behavior...
        else {
            return true
        }

        // ...otherwise return false since the updates have already
        // been made
        return false
    }
    
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if self.view.window != nil {
            if textView.textColor == placeholderColor {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
        }
    }
}

extension RecoveryPhraseVC: ScannerDelegate {
    func getValue(_ value: String) {
        recoveryTextView.text = value
        clearButton.isHidden = false
        scanButton.isHidden = true
    }
}

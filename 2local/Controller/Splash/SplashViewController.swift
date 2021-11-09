//
//  SplashViewController.swift
//  2local
//
//  Created by Hasan Sedaghat on 12/28/19.
//  Copyright © 2019 2local Inc. All rights reserved.
//

import UIKit
import KVNProgress
import MaterialComponents
class SplashViewController: BaseVC {
    
    @IBAction func unwindToSplash(segue:UIStoryboardSegue) {
        viewDidAppear(false)
    }
    
    @IBOutlet var indicator: MDCActivityIndicator! {
        didSet {
            indicator.radius = 15
            indicator.cycleColors = [._flamenco,._gainsboro]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //        if LocalDataManager.shared.hasPassword {
        if LocalDataManager.shared.hasToken {
            getProfile()
            getMarketplaces()
        } else {
            //                addWallets()
            goToOnboarding()
        }
        
        //        } else {
        //            goToOnboarding()
        //        }
    }
    
    func goToLocalLogin() {
        let vc = UIStoryboard.authentication.instantiate(viewController: LocalLoginVC.self)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    fileprivate func goToLogin() {
        //        showLoginView(self)
        let vc = UIStoryboard.authentication.instantiate(viewController: LoginViewController.self)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    fileprivate func goToHome() {
        let vc = TabbarVC()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    fileprivate func goToOnboarding() {
        let vc = UIStoryboard.intro.instantiate(viewController: OnBoardingViewController.self)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    func getProfile() {
        indicator.startAnimating()
        let userId = LocalDataManager.shared.user?.id ?? DataProvider.shared.user?.id ?? -1
        APIManager.shared.getProfile(userId: userId) { (data, response, error) in
            let result = APIManager.processResponse(response: response, data: data)
            if result.status {
                do {
                    if let user = try JSONDecoder().decode(ResultData<User>.self, from: data!).record {
                        DataProvider.shared.user = user
                        LocalDataManager.shared.setUser(user)
                        LocalDataManager.shared.setToken(LocalDataManager.shared.user?.accessToken ?? LocalDataManager.shared.user?.apiToken ?? "")
                        self.addWallets()
                    }
                    else {
                        DispatchQueue.main.async {
                            KVNProgress.showError(withStatus: "Failed to parse profile data\nPlease contact us.")
                        }
                    }
                }
                catch {
                    DispatchQueue.main.async {
                        KVNProgress.showError(withStatus: "Failed to parse profile data\nPlease contact us.")
                    }
                }
            } else {
                DispatchQueue.main.async {
                    //                    KVNProgress.showError(withStatus: result.message)
                    DataProvider.shared.keychain.clear()
                    self.goToLogin()
                }
            }
        }
    }
    
    fileprivate func addWallets() {
        
        let currentWallets = DataProvider.shared.wallets
        
        /// Get and add Smart chain tokens  data
        if let pk = userDefaults.string(forKey: UserDefaultsKey.TLCWallet.rawValue) {
            do {
                try Web3Service.shared.import2LCBy(privateKey: pk) { [weak self] walletAddress in
                    guard let _ = self, let address = walletAddress else { return }
                    
                    do {
                        ///get the 2LC token balance
                        let tlcBalance = try Web3Service.shared.getBEP20TokenBalance(walletAddress: address)
                        
                        ///add the 2LC token in list
                        let tlc = Wallets(name: .TLocal, balance: tlcBalance ?? "0", address: address, mnemonic: nil, displayName: Coins.TLocal.rawValue)
                        
                        if currentWallets.count > 0 {
                            for i in 0..<currentWallets.count {
                                if currentWallets.filter({$0.name == currentWallets[i].name}).first != nil {
                                    DataProvider.shared.wallets.remove(at: i)
                                    DataProvider.shared.wallets.insert(tlc, at: i)
                                } else {
                                    DataProvider.shared.wallets.append(tlc)
                                }
                            }
                        } else {
                            DataProvider.shared.wallets.append(tlc)
                        }
                        
                    } catch {
                        print("2LC balance error")
                    }
                    
                    do {
                        ///get the BNB token balance
                        let bnbBalance = try Web3Service.shared.getBNBBalance(walletAddress: address)
                        
                        ///add the BNB token in list
                        let bnb = Wallets(name: .Binance, balance: bnbBalance , address: address, mnemonic: nil, displayName: Coins.Binance.rawValue)
                        
                        if currentWallets.count > 0 {
                            for i in 0..<currentWallets.count {
                                if currentWallets.filter({$0.name == currentWallets[i].name}).first != nil {
                                    DataProvider.shared.wallets.remove(at: i)
                                    DataProvider.shared.wallets.insert(bnb, at: i)
                                } else {
                                    DataProvider.shared.wallets.append(bnb)
                                }
                            }
                        } else {
                            DataProvider.shared.wallets.append(bnb)
                        }
                        
                    } catch {
                        print("BNB balance error")
                    }
                }
            } catch {
                print("Import 2lc token error")
            }
        }
        
        /// Get and add Ethereum wallet data
        if let mnemonics = userDefaults.string(forKey: UserDefaultsKey.ETHWallet.rawValue) {
            let address = Web3Service.currentAddress
            Web3Service.getETHBalance { (balance) in
                let eth = Wallets(name: .Ethereum, balance: balance ?? "0", address: address, mnemonic: mnemonics, displayName: Coins.Ethereum.rawValue)
                
                if currentWallets.count > 0 {
                    for i in 0..<currentWallets.count {
                        if currentWallets.filter({$0.name == currentWallets[i].name}).first != nil {
                            DataProvider.shared.wallets.remove(at: i)
                            DataProvider.shared.wallets.insert(eth, at: i)
                        } else {
                            DataProvider.shared.wallets.append(eth)
                        }
                    }
                } else {
                    DataProvider.shared.wallets.append(eth)
                }
            }
        }
        
        ///update coin, wallet or token list in app
        NotificationCenter.default.post(name: Notification.Name.wallet, object: nil)
        
        DispatchQueue.main.async {
            self.goToHome()
        }
    }
    
    func getMarketplaces() {
        APIManager.shared.getMarketplaces { (data, response, error) in
            let result = APIManager.processResponse(response: response, data: data)
            if result.status {
                do {
                    guard let record = try JSONDecoder().decode(ResultData<Place>.self, from: data!).record?.companies else {
                        DispatchQueue.main.async {
                            KVNProgress.showError(withStatus: "Failed to parse marketplaces data\nPlease contact us.")
                        }
                        return
                    }
                    DataProvider.shared.places = record
                }
                catch {
                    DispatchQueue.main.async {
                        KVNProgress.showError(withStatus: "Failed to parse marketplaces data\nPlease contact us.")
                    }
                }
            } else {
                DispatchQueue.main.async {
                    KVNProgress.showError(withStatus: "Failed to get marketplaces data\nPlease contact us.")
                }
            }
        }
    }
}


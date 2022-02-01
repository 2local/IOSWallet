//
//  TabbarVC.swift
//  2local
//
//  Created by Ebrahim Hosseini on 7/27/21.
//  Copyright © 2021 2local Inc. All rights reserved.
//

import UIKit

class TabbarVC: UITabBarController {

    // MARK: - Outlets

    // MARK: - Properties
    enum TabBarItemType: Int {
        case home = 0
        case scanner
        case marketPlace
        case wallet
    }

    // MARK: - View cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTabbar()
        DashboardVC().setupNotifications()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    // MARK: - Functions
    fileprivate func setupView() {

    }

    fileprivate func setupTabbar() {
        let topAndBottonInset: CGFloat = self.tabBar.hasHomeIndicator ? 0 : 0// 7 : 0

        // HOME
        let homeVC = UIStoryboard.dashboard.instantiate(viewController: DashboardVC.self)
        let homeTabBar = UITabBarItem(title: "Home",
                                      image: UIImage(named: "home")?.tint(with: .topaz),
                                      selectedImage: UIImage(named: "home")?.tint(with: .flamenco))
        homeTabBar.imageInsets = .init(top: topAndBottonInset,
                                       left: 0,
                                       bottom: -topAndBottonInset,
                                       right: 0)
        homeVC.tabBarItem = homeTabBar
        homeTabBar.tag = TabBarItemType.home.rawValue
        let homeNavigatioinController = TLNavigationController(rootViewController: homeVC)

        // SCANNER
        let scannerVC = UIStoryboard.scan.instantiate(viewController: ScanViewController.self)
        let scannerTabBar = UITabBarItem(title: "Scan",
                                         image: UIImage(named: "scan")?.tint(with: .topaz),
                                         selectedImage: UIImage(named: "scan")?.tint(with: .flamenco))
        scannerTabBar.imageInsets = .init(top: topAndBottonInset,
                                          left: 0,
                                          bottom: -topAndBottonInset,
                                          right: 0)
        scannerVC.tabBarItem = scannerTabBar
        scannerVC.initWith(true)
        scannerTabBar.tag = TabBarItemType.scanner.rawValue
        let scannerNavigatioinController = TLNavigationController(rootViewController: scannerVC)

        // MARKETPLACE
        let marketplaceVC = UIStoryboard.marketplace.instantiate(viewController: MarketplaceVC.self)
        let marketplaceTabBar = UITabBarItem(title: "Marketplace",
                                             image: UIImage(named: "market")?.tint(with: .topaz),
                                             selectedImage: UIImage(named: "market")?.tint(with: .flamenco))
        marketplaceTabBar.imageInsets = .init(top: topAndBottonInset,
                                              left: 0,
                                              bottom: -topAndBottonInset,
                                              right: 0)
        marketplaceVC.tabBarItem = marketplaceTabBar
        marketplaceTabBar.tag = TabBarItemType.marketPlace.rawValue
        let marketplaceNavigatioinController = TLNavigationController(rootViewController: marketplaceVC)

        // WALLET
        let wallletVC = UIStoryboard.wallet.instantiate(viewController: WalletsListVC.self)
        let walletTabBar = UITabBarItem(title: "Wallet",
                                        image: UIImage(named: "wallet")?.tint(with: .topaz),
                                        selectedImage: UIImage(named: "wallet")?.tint(with: .flamenco))
        walletTabBar.imageInsets = .init(top: topAndBottonInset,
                                         left: 0,
                                         bottom: -topAndBottonInset,
                                         right: 0)
        wallletVC.tabBarItem = walletTabBar
        walletTabBar.tag = TabBarItemType.wallet.rawValue
        let walletNavigatioinController = TLNavigationController(rootViewController: wallletVC)

        viewControllers = [homeNavigatioinController,
                           scannerNavigatioinController,
                           marketplaceNavigatioinController,
                           walletNavigatioinController]

        tabBar.isTranslucent = false
        tabBar.backgroundColor = .tabbarBack
        tabBar.tintColor = .flamenco

        // set HOME view as first view to show
        self.selectedIndex = TabBarItemType.home.rawValue

    }

    // MARK: - Actions

}

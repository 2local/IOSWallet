//
//  AppDelegate.swift
//  2local
//
//  Created by Hasan Sedaghat on 12/28/19.
//  Copyright © 2019 2local Inc. All rights reserved.
//

import UIKit
import KVNProgress
import GoogleMaps
import GooglePlaces
import Firebase
import FirebaseRemoteConfig
import Branch
import LocalAuthentication
import FirebaseCrashlytics

public let walletQueue = DispatchQueue.global(qos: .userInitiated)

var remoteConfig = RemoteConfig.remoteConfig()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window : UIWindow?
  let context = LAContext()
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    FirebaseApp.configure()
    
    self.logUser()
    
    let googleApiKey = Constant.googleAPIKey
    
    GMSServices.provideAPIKey(googleApiKey)
    GMSPlacesClient.provideAPIKey(googleApiKey)
    
    setupProgressConfiguration()
    
    Branch.getInstance().initSession(launchOptions: launchOptions) { (params, error) in
      // do stuff with deep link data (nav to page, display content, etc)
      print(params as? [String: AnyObject] ?? {})
    }
    
    return true
  }
  
  func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    return Branch.getInstance().application(app, open: url, options: options)
  }
  
  func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
    // handler for Universal Links
    return Branch.getInstance().continue(userActivity)
  }
  
  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    // handler for Push Notifications
    Branch.getInstance().handlePushNotification(userInfo)
  }
  
  func logUser() {
    Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(true)
    if let user = DataProvider.shared.user {
      Crashlytics.crashlytics().setUserID("\(user.id ?? 1)")
      Crashlytics.crashlytics().setCustomValue("\(user.name ?? "no name") \(user.lastName ?? "no lastName")", forKey: "str_key")
    }
  }
  
}

//MARK: - App life cycle

extension AppDelegate {
  
  // Detects when the user returns to the Home screen, which will push the app into the background
  func applicationWillResignActive(_ application: UIApplication) {
    print("LIFECYCLE-> \(#function)")
  }
  
  // Detects when an app, formerly in the background, reappears in the foreground once more
  func applicationDidBecomeActive(_ application: UIApplication) {
    print("LIFECYCLE-> \(#function)")
  }
  
  // Detects when an app gets sent into the background
  func applicationDidEnterBackground(_ application: UIApplication) {
    print("LIFECYCLE-> \(#function)")
  }
  
  // Detects when an app is about to be sent into the background
  func applicationWillEnterForeground(_ application: UIApplication) {
    print("LIFECYCLE-> \(#function)")
    //        if LocalDataManager.shared.hasPassword {
    //            goToLoginView()
    //        } else {
    //            goToCreatePassword()
    //        }
  }
  
  // Detects when an app is about to stop running
  func applicationWillTerminate(_ application: UIApplication) {
    print("LIFECYCLE-> \(#function)")
  }
  
  fileprivate func goToLoginView() {
    let vc = UIStoryboard.authentication.instantiate(viewController: LocalLoginVC.self)
    vc.modalPresentationStyle = .fullScreen
    self.window = UIWindow(frame: UIScreen.main.bounds)
    self.window?.rootViewController = vc
    self.window?.makeKeyAndVisible()
  }
  
  fileprivate func goToCreatePassword() {
    let vc = UIStoryboard.authentication.instantiate(viewController: CreatePasswordVC.self)
    vc.modalPresentationStyle = .fullScreen
    self.window = UIWindow(frame: UIScreen.main.bounds)
    self.window?.rootViewController = vc
    self.window?.makeKeyAndVisible()
  }
  
}

//MARK: - Progress configuration

extension AppDelegate {
  fileprivate func setupProgressConfiguration() {
    let HSProgressConfiguration = KVNProgressConfiguration()
    HSProgressConfiguration.statusFont = .TLFont(weight: .medium,
                                                 size: 16)
    HSProgressConfiguration.minimumErrorDisplayTime = 3
    HSProgressConfiguration.minimumSuccessDisplayTime = 2.8
    HSProgressConfiguration.circleSize = 50
    HSProgressConfiguration.circleStrokeForegroundColor = ._flamenco
    HSProgressConfiguration.errorColor = ._flamenco
    HSProgressConfiguration.successColor = ._flamenco
    HSProgressConfiguration.statusColor = UIColor._404040
    HSProgressConfiguration.stopColor = ._flamenco
    HSProgressConfiguration.backgroundType = .blurred
    HSProgressConfiguration.backgroundTintColor = UIColor._EBEBEB
    KVNProgress.setConfiguration(HSProgressConfiguration)
  }
}

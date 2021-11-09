//
//  OpenUrls.swift
//  2local
//
//  Created by Ibrahim Hosseini on 11/9/21.
//  Copyright © 2021 2local Inc. All rights reserved.
//

import UIKit
import SafariServices

public func openUrl(_ url: String, viewController: UIViewController) {
    var urlAdrs: URL!
    if url.hasPrefix("http") {
        urlAdrs = URL(string: url)!
    } else {
        if url.hasPrefix("/") {
            url.dropFirst()
        }
        urlAdrs = URL(string: "\("https://2local.io/")\(url)")!
    }
    
    if !UIApplication.shared.canOpenURL(urlAdrs) {
        return
    }
    
    let vc = SFSafariViewController(url: urlAdrs)
    viewController.present(vc, animated: true, completion: nil)
}

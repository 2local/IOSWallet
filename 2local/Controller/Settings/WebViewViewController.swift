//
//  WebViewViewController.swift
//  2local
//
//  Created by Hasan Sedaghat on 1/9/20.
//  Copyright © 2020 2local Inc. All rights reserved.
//

import UIKit
import WebKit
class WebViewViewController: BaseVC {

    @IBOutlet var webView: WKWebView!
    var url = "https://2local.io"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if url.hasPrefix("http") {
            webView.load(URLRequest.init(url: url.getCleanedURL()!))
        } else {
            let str2 = Bundle.main.resourceURL?.appendingPathComponent(url)
            webView.loadFileURL(str2!, allowingReadAccessTo: str2!)
        }
    }

}

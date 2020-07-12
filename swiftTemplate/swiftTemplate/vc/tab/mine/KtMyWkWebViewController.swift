//
//  KtMyWkWebViewController.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/7/9.
//  Copyright © 2020 SwiftKt-王波. All rights reserved.
//

import UIKit
import WebKit
class KtMyWkWebViewController: BaseViewController {
    var url : URL? = nil
    @IBOutlet weak var webview: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        webview.isOpaque = false
        webview.backgroundColor = .clear
        webview.scrollView.backgroundColor = .clear
        url = URL(fileURLWithPath: Bundle.main.path(forResource: "用户隐私协议", ofType: ".html",inDirectory: "HTML")!)
        loadWebView()
        let request = URLRequest(url:url!)
        webview.load(request)
//        let colo = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        
        //                webview.configuration.userContentController.add(self, name: "ios_call")
        
    }
    func loadWebView()  {
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        configuration.userContentController = WKUserContentController()
        configuration.userContentController.add(self, name: "AppModel")
        webview.scrollView.bounces = true
        webview.scrollView.alwaysBounceVertical = true
        webview.navigationDelegate = self
    }
    
}
extension KtMyWkWebViewController: WKNavigationDelegate, WKScriptMessageHandler{
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
    }
    
    
}

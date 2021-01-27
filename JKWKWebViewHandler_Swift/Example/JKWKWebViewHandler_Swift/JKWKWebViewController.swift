//
//  JKWKWebViewController.swift
//  JKWKWebViewHandler_Swift_Example
//
//  Created by JackLee on 2021/1/25.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import WebKit
import JKWKWebViewHandler_Swift

class JKWKWebViewController: UIViewController,WKNavigationDelegate,WKUIDelegate,JKEventHandlerProtocol {
    
    
   public var url:String?
    var webView:WKWebView?
    var eventHandler:JKEventHandlerSwift!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureWKWebView()
        
    }
    
    func configureWKWebView() -> Void {
        self.eventHandler = JKEventHandlerSwift.init(webView, self)
        let config:WKWebViewConfiguration = WKWebViewConfiguration.init()
        config.preferences = WKPreferences.init()
        config.preferences.minimumFontSize = 10
        config.preferences.javaScriptEnabled = true
        config.preferences.javaScriptCanOpenWindowsAutomatically = true
        config.processPool = WKProcessPool.init()
        
        let usrScript:WKUserScript = WKUserScript.init(source: JKEventHandlerSwift.handleJS()!, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        config.userContentController = WKUserContentController.init()
        config.userContentController.addUserScript(usrScript)
        config.userContentController.add(self.eventHandler, name: JKEventHandlerNameSwift)
        
        self.webView = WKWebView.init(frame: self.view.bounds, configuration: config)
        self.webView?.load(URLRequest.init(url: URL.init(string: self.url!)!))
        self.view.addSubview(self.webView!)
        self.eventHandler.webView = self.webView
        self.webView?.uiDelegate = self;
    }
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alert = UIAlertController.init(title: "alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "确定", style: .default, handler: { (_ acton:UIAlertAction) in
            completionHandler()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    //MARK:JKEventHandlerProtocol
    func nativeHandle(plugin: String?, funcName: inout String!, params: Dictionary<String, Any>?, success: ((Any?) -> Void)?, failure: ((Any?) -> Void)?) {
        if plugin == "JKPluginA" {
            JKPluginA.getNativeInfo(params: params ?? [:], successCallBack: success, failureCallBack: failure)
        }
    }
    
}




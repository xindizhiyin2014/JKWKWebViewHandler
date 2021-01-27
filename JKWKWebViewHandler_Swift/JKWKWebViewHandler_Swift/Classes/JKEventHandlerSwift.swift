//
//  JKEventHandlerSwift.swift
//  JKWKWebViewHandler_Swift
//
//  Created by JackLee on 2021/1/23.
//

import Foundation
import WebKit
public let JKEventHandlerNameSwift = "JKEventHandler"

public protocol JKEventHandlerProtocol:class,NSObjectProtocol {
    func nativeHandle(plugin:String?, funcName:inout String!, params:Dictionary<String, Any>?, success:((_ response:Any?) -> Void)?, failure:((_ response:Any?) -> Void)?) -> Void
    
}

open class JKEventHandlerSwift: NSObject,WKScriptMessageHandler {
    
 public weak var webView:WKWebView!
    weak var delegate:JKEventHandlerProtocol?
    
    public init(_ webView:WKWebView!,_ delegate:JKEventHandlerProtocol!) {
        super.init()
        self.webView = webView
        self.delegate = delegate
    }
  public class func handleJS() -> String? {
    let path:String = Bundle.init(for: self).path(forResource: "JKEventHandler", ofType: "js") ?? ""
    var jsString:String?
    do {
        try jsString = String.init(contentsOfFile: path, encoding: String.Encoding.utf8)
    } catch  {
        #if DEBUG
        print("JKEventHandlerNameSwift error:%@",error)
        #endif
    }
    jsString = jsString?.replacingOccurrences(of: "\n", with: "")
    return jsString
    }
    
    /// 清空handler的数据信息， 注入的脚本。绑定事件信息等等
    /// - Parameter handler: handler
    /// - Returns: void
    public func cleanHandler( handler:inout JKEventHandlerSwift!) -> Void {
    if (handler.webView != nil) {
        handler.webView.evaluateJavaScript("JKEventHandler.removeAllCallBacks();", completionHandler: nil)
        handler.webView.configuration.userContentController.removeScriptMessageHandler(forName: JKEventHandlerNameSwift)
    }
        #warning("todo")
    handler = nil
    }

    /// 执行js脚本
    /// - Parameters:
    ///   - js: js
    ///   - completed: completed
    /// - Returns: void
   public func evaluateJavaScript(js:String!, withCompleted completed:((_ data:Any?, _ error:Error?) ->Void)?) -> Void {
    self.webView.evaluateJavaScript(js, completionHandler: { (data:Any?, error:Error?) in
        completed?(data,error)
    })
    }
    
    /// 执行js脚本，同步返回
    /// - Parameters:
    ///   - js: js
    ///   - error: error
    /// - Returns: void
    public func synEvaluateJavaScript(js:String!, withError error:inout UnsafeMutablePointer<Error>?) -> Any? {
        var result:Any?
        var success:Bool? = false
        var result_Error:Error?
        self.evaluateJavaScript(js: js, withCompleted: { (data:Any?, tmp_error:Error?) in
            if tmp_error != nil {
                result = data
                success = true
            } else {
                result_Error = tmp_error
            }
        })
        
        while success != nil {
            RunLoop.current.run(mode: .defaultRunLoopMode, before: .distantFuture)
        }
        
        if error != nil {
            do {
                try error = withUnsafeMutablePointer(to: &result_Error, result_Error as! (UnsafeMutablePointer<Error?>) throws -> UnsafeMutablePointer<Error>?)
            } catch  {
                #if DEBUG
                print("JKEventHandlerNameSwift error:%@",error)
                #endif
            }
        }
        return result
            
    }
    
    
    //MARK: WKScriptMessageHandler
   public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            if message.name == JKEventHandlerNameSwift {
                let body:Dictionary? = message.body as? Dictionary<String, Any>;
                let plugin:String? = (body!["plugin"] as! String)
                var funcName:String? = (body!["func"] as! String)
                let params:Dictionary? = (body!["params"] as! Dictionary<String, Any>)
                let successCallBackID:String? = (body!["successCallBackID"] as! String)
                let failureCallBackID:String? = (body!["failureCallBackID"] as! String)
                self.interactWithPlguin(plugin: plugin, withFuncName: &funcName, withParams: params, withSuccess: { (response:Any?) in
                    self.callJSWithCallbackName(callbackName: successCallBackID, response: response)
                }, withFailure: { (response:Any?) in
                    self.callJSWithCallbackName(callbackName: failureCallBackID, response: response)
                })

            }
        }
    
   private func interactWithPlguin(plugin:String?, withFuncName funcName:inout String!, withParams params:Dictionary<String, Any>?, withSuccess success:((_ response:Any?) -> Void)?, withFailure failure:((_ response:Any?) -> Void)?) -> Void {
    
    if ((self.delegate?.responds(to:Selector("nativeHandle:::"))) != nil) {
        self.delegate?.nativeHandle(plugin: plugin, funcName: &funcName, params: params, success: success, failure: failure)
    } else {
        if failure != nil {
            let error:String = "unSupported error!"
            failure!(error)
        }
    }
    
    }
    
   private func callJSWithCallbackName(callbackName:String!, response:Any?) -> Void {
        var responseString:String = response as! String
        if response is Dictionary<String,Any>
            || response is Array<Any> {
            var jsonData:Data
            do {
                try jsonData = JSONSerialization.data(withJSONObject: response!, options: .prettyPrinted)
                var jsonString:String = String.init(data: jsonData , encoding: .utf8) ?? ""
                jsonString = jsonString.replacingOccurrences(of: "\n", with: "")
                responseString = jsonString
            } catch  {
                #if DEBUG
                print("JKEventHandlerNameSwift error:%@",error)
                #endif
            }
        }
        let jsString:String = String.init(format: "JKEventHandler.callBack('%@','%@');", callbackName,responseString)
        self.webView.evaluateJavaScript(jsString, completionHandler: { (data:Any?, error:Error?) in
            #if DEBUG
            print("JKEventHandler.callBack:\ndata: error%@\n error: %@\n",data as Any,error as Any)
            #endif
        })

    }
    
    
}

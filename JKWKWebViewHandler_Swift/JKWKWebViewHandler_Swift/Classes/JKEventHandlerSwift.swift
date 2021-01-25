//
//  JKEventHandlerSwift.swift
//  JKWKWebViewHandler_Swift
//
//  Created by JackLee on 2021/1/23.
//

import Foundation
import WebKit
let JKEventHandlerNameSwift:String = "JKEventHandler"
class JKEventHandlerSwift: NSObject,WKScriptMessageHandler {
    
  weak var webView:WKWebView!
    
  public class func handleJS() -> String? {
    let path:String = Bundle.init(for: self).path(forResource: "JKEventHandler", ofType: "js") ?? ""
    var jsString:String?
    do {
        try jsString = String.init(contentsOfFile: path, encoding: String.Encoding.utf8)
    } catch  {
        print("JKEventHandlerNameSwift error:%@",error)
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
   public func evaluateJavaScript(js:String!, withCompleted completed:(data:Any?, error:Error?)) -> Void {
    self.webView.evaluateJavaScript(js, completionHandler: { (data:Any?, error:Error?) in
        #warning("todo")
    })
    }
    
    /// 执行js脚本，同步返回
    /// - Parameters:
    ///   - js: js
    ///   - error: error
    /// - Returns: void
    public func synEvaluateJavaScript(js:String!, withError error:Error) -> Void {
        
    }
    
    
    //MARK: WKScriptMessageHandler
        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            if message.name == JKEventHandlerNameSwift {
                let body:Dictionary? = message.body as? Dictionary<String, Any>;
                let plugin:String? = (body!["plugin"] as! String)
                let funcName:String? = (body!["func"] as! String)
                let params:Dictionary? = (body!["params"] as! Dictionary<String, Any>)
                let successCallBackID:String? = (body!["successCallBackID"] as! String)
                let failureCallBackID:String? = (body!["failureCallBackID"] as! String)
                self.interactWithPlguin(plugin: plugin, withFuncName: funcName, withParams: params, withSuccess: { (response:Any?) in
                    self.callJSWithCallbackName(callbackName: successCallBackID, response: response)
                }, withFailure: { (response:Any?) in
                    self.callJSWithCallbackName(callbackName: failureCallBackID, response: response)
                })

            }
        }
    
   private func interactWithPlguin(plugin:String?, withFuncName funcName:String!, withParams params:Dictionary<String, Any>?, withSuccess success:(_ response:Any?) -> Void, withFailure failure:(_ response:Any?) -> Void) -> Void {
        
    }
    
    func callJSWithCallbackName(callbackName:String!, response:Any?) -> Void {
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
            print("JKEventHandler.callBack: %@\n response: %@",callbackName,response as Any)
            #endif
        })

    }
    
    
}

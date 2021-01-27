//
//  JKEventHandleDelegate.swift
//  JKWKWebViewHandler_Swift_Example
//
//  Created by JackLee on 2021/1/27.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import JKWKWebViewHandler_Swift
class JKEventHandleDelegate: NSObject, JKEventHandlerProtocol {
    func nativeHandle(plugin: String?, funcName: inout String!, params: Dictionary<String, Any>?, success: ((Any?) -> Void)?, failure: ((Any?) -> Void)?) {
        if plugin == "JKPluginA" {
            JKPluginA.getNativeInfo(params: params ?? [:], successCallBack: success, failureCallBack: failure)
        }
    }
    
}

//
//  JKPluginA.swift
//  JKWKWebViewHandler_Swift_Example
//
//  Created by JackLee on 2021/1/26.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
class JKPluginA: NSObject {
 class func getNativeInfo(params:Dictionary<String,Any>, successCallBack:((_ response:Any?) -> Void)?, failureCallBack:((_ response:Any?) -> Void)?) -> Void {
        if successCallBack != nil {
            successCallBack!("success !")
        }
        
        if failureCallBack != nil {
            failureCallBack!("failure !")
        }
    }
}

//
//  JKEventPluginManager.swift
//  JKWKWebViewHandler_Swift
//
//  Created by JackLee on 2021/1/26.
//

import Foundation
open class JKEventPluginManager:NSObject {
  private var pluginMap:Dictionary<String,String> = [:]
   private let lock:NSLock = NSLock()
    
   public static let sharedManager:JKEventPluginManager = JKEventPluginManager()
    
  public func registerPlugin(pluginName:String!,pluginClassName:String, nameSpace:String!) -> Void {
        self.lock.lock()
        let value:String? = self.pluginMap[pluginName]
        if value != nil {
            self.pluginMap[pluginName] = String.init(format: "%@.%@", nameSpace,pluginClassName)
        }
        self.lock.unlock()
    }
    
   public func registerPlugin(pluginName:String!, withClass pluginClass:AnyClass!) -> Void {
        self.lock.lock()
        let className = NSStringFromClass(pluginClass)
        self.pluginMap[pluginName] = className
        self.lock.unlock()
    }
    
   public func className(withPluginName pluginName:String!) -> String? {
        return self.pluginMap[pluginName]
    }
    
    
    
    
}

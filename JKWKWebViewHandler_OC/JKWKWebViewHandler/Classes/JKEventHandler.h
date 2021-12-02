//
//  JKEventHandler.h
//  Pods
//
//  Created by Jack on 17/3/31.
//
//

#import <Foundation/Foundation.h>
#import <webkit/webkit.h>

static NSString * const JKEventHandlerName = @"JKEventHandler";

@interface JKEventHandler : NSObject<WKScriptMessageHandler>

@property (nonatomic, weak) WKWebView *webView;
/// 插件字典，key：插件的名字，value：插件的具体对象，ps：可以是实例对象，也可以是类对象
@property (nonatomic, strong) NSDictionary <NSString*,id>*pluginsDic;

+ (NSString *)handlerJS;

/**
 清空handler的数据信息， 注入的脚本。绑定事件信息等等
 */
+ (void)cleanHandler:(JKEventHandler *)handler;

/**
 执行js脚本

 @param js js脚本
 @param completed 回调
 */
- (void)evaluateJavaScript:(NSString *)js
                 completed:(void(^)(id data, NSError *error))completed;

/// 执行js脚本，同步返回
/// @param js js脚本
/// @param error 错误
- (id)synEvaluateJavaScript:(NSString *)js
                      error:(NSError **)error;

@end

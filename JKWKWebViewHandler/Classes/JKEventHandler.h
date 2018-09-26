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
- (void)evaluateJavaScript:(NSString *)js completed:(void(^)(id data, NSError *error))completed;

@end

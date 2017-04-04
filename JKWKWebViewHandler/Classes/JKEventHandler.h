//
//  JKEventHandler.h
//  Pods
//
//  Created by Jack on 17/3/31.
//
//

#import <Foundation/Foundation.h>
#import <webkit/webkit.h>

extern const NSString *EventHandler;

@interface JKEventHandler : NSObject<WKScriptMessageHandler>

@property (nonatomic, weak) WKWebView *webView;
@property (nonatomic, strong) NSString  *handlerJS;

+ (instancetype)shareInstance;


+ (void)getInject:(WKWebView *)webView;

@end

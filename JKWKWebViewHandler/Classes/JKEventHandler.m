//
//  JKEventHandler.m
//  Pods
//
//  Created by Jack on 17/3/31.
//
//

#import "JKEventHandler.h"
#import <webkit/webkit.h>
#import <objc/message.h>

#ifdef DEBUG
#define JKEventHandlerLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define JKEventHandlerLog(...)
#endif

const NSString *EventHandler = @"JKEventHandler";

@interface JKEventHandlerEmptyObject :NSObject

@end

@implementation JKEventHandlerEmptyObject

@end

@implementation JKEventHandler

static JKEventHandler * _handler= nil;
+ (instancetype)shareInstance{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _handler =[JKEventHandler new];
        _handler.handlerJS = [_handler getJsString];
        
    });
    return _handler;
}


- (NSString *)getJsString{

    NSString *path =[[NSBundle bundleForClass:[self class]] pathForResource:@"JKEventHandler" ofType:@"js"];
    NSString *handlerJS = [NSString stringWithContentsOfFile:path encoding:kCFStringEncodingUTF8 error:nil];
    handlerJS = [handlerJS stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return handlerJS;
}

+ (void)getInject:(WKWebView *)webView{

    
    [JKEventHandler shareInstance].webView = webView;
    
}


#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message {
   // NSLog(@"message :%@",message.body);
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored"-Wincompatible-pointer-types-discards-qualifiers"
    if ([message.name isEqualToString:EventHandler]) {
   #pragma clang diagnostic pop
        NSString *methodName = message.body[@"methodName"];
        NSDictionary *params = message.body[@"params"];
        
        NSString *type = message.body[@"type"];
        if ([type isEqualToString:@"NewJSFunction"]) {
            NSString *successCallBackID = message.body[@"successCallBackID"];
            NSString *failureCallBackID = message.body[@"failureCallBackID"];
            __weak typeof(self) weakSelf = self;
                [self newInteractWitMethodName:methodName params:params success:^(id response) {
                    [weakSelf _jkCallJSCallBackWithCallBackName:successCallBackID response:response];
                } failure:^(id response) {
                    [weakSelf _jkCallJSCallBackWithCallBackName:failureCallBackID response:response];
                }];
        }else{
            NSString *callBackName = message.body[@"callBackID"];
            if (callBackName) {
                __weak typeof(self) weakSelf = self;
                [self interactWitMethodName:methodName params:params :^(id response) {
                    
                    [weakSelf _jkCallJSCallBackWithCallBackName:callBackName response:response];
                }];
            }else{
                [self interactWitMethodName:methodName params:params :nil];
            }
        }
        
    }
    
    
}


- (void)interactWitMethodName:(NSString *)methodName params:(NSDictionary *)params :(void(^)(id response))callBack{
    
    if (params) {
        methodName = [NSString stringWithFormat:@"%@:",methodName];
        if (callBack) {
            methodName = [NSString stringWithFormat:@"%@:",methodName];
            SEL selector =NSSelectorFromString(methodName);
            NSArray *paramArray =@[params,callBack];
            if ([self respondsToSelector:selector]) {
                [self _jkPerformSelector:selector withObjects:paramArray];
            }
        }else{
            SEL selector =NSSelectorFromString(methodName);
            NSArray *paramArray =@[params];
            if ([self respondsToSelector:selector]) {
                [self _jkPerformSelector:selector withObjects:paramArray];
            }
        }
    }else{
        
        if (callBack) {
            methodName = [NSString stringWithFormat:@"%@:",methodName];
            SEL selector =NSSelectorFromString(methodName);
            NSArray *paramArray =@[callBack];
            if ([self respondsToSelector:selector]) {
                [self _jkPerformSelector:selector withObjects:paramArray];
            }
        }else{
            SEL selector =NSSelectorFromString(methodName);
            
            if ([self respondsToSelector:selector]) {
                [self _jkPerformSelector:selector withObjects:nil];
            }
        }
    }
}

- (void)newInteractWitMethodName:(NSString *)methodName params:(NSDictionary *)params success:(void(^)(id response))successCallBack failure:(void(^)(id response))failureCallBack{
    if (params) {
        methodName = [NSString stringWithFormat:@"%@:",methodName];
        
            methodName = [NSString stringWithFormat:@"%@::",methodName];
            SEL selector =NSSelectorFromString(methodName);
        id successBlock=nil;
        if (successCallBack) {
            successBlock = successCallBack;
        }else{
            successBlock = [JKEventHandlerEmptyObject class];
        }
        
        id failureBlock=nil;
        if (failureCallBack) {
            failureBlock = failureCallBack;
        }else{
            failureBlock = [JKEventHandlerEmptyObject class];
        }
            NSArray *paramArray =@[params,successBlock,failureBlock];
            if ([self respondsToSelector:selector]) {
                [self _jkPerformSelector:selector withObjects:paramArray];
            }
        
        
    }
}

- (id)_jkPerformSelector:(SEL)aSelector withObjects:(NSArray *)objects {
    NSMethodSignature *signature = [self methodSignatureForSelector:aSelector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:self];
    [invocation setSelector:aSelector];

    NSUInteger i = 1;
    
    for (id object in objects) {
        id tempObject = object;
        if (![tempObject isKindOfClass:[NSObject class]]) {
            if ([tempObject isSubclassOfClass:[JKEventHandlerEmptyObject class]]) {
                tempObject = nil;
            }
        }
        [invocation setArgument:&tempObject atIndex:++i];
    }
    [invocation invoke];
    
    if ([signature methodReturnLength]) {
        id data;
        [invocation getReturnValue:&data];
        return data;
    }
    return nil;
}

- (void)_jkCallJSCallBackWithCallBackName:(NSString *)callBackName response:(id)response{
    __weak  WKWebView *weakWebView = _webView;
    NSString *js = [NSString stringWithFormat:@"JKEventHandler.callBack('%@','%@');",callBackName,response];
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakWebView evaluateJavaScript:js completionHandler:^(id _Nullable data, NSError * _Nullable error) {
            JKEventHandlerLog(@"JKEventHandler.callBack: %@\n response: %@",callBackName,response);
        }];
    });
}






@end

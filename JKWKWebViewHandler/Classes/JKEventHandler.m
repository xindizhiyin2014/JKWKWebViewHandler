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


@interface JKEventHandlerEmptyObject :NSObject

@end

@implementation JKEventHandlerEmptyObject

@end

@implementation JKEventHandler

+ (void)cleanHandler:(JKEventHandler *)handler{
    if (handler.webView) {
        [handler.webView evaluateJavaScript:@"JKEventHandler.removeAllCallBacks();" completionHandler:nil];//删除所有的回调事件
        [handler.webView.configuration.userContentController removeScriptMessageHandlerForName:JKEventHandlerName];
    }
    handler = nil;
    
}

+ (NSString *)handlerJS{

    NSString *path =[[NSBundle bundleForClass:[self class]] pathForResource:@"JKEventHandler" ofType:@"js"];
    NSString *handlerJS = [NSString stringWithContentsOfFile:path encoding:kCFStringEncodingUTF8 error:nil];
    handlerJS = [handlerJS stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return handlerJS;
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message {
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored"-Wincompatible-pointer-types-discards-qualifiers"
    if ([message.name isEqualToString:JKEventHandlerName]) {
   #pragma clang diagnostic pop
        NSString *plugin = message.body[@"plugin"];
        NSString *funcName = message.body[@"func"];
        NSDictionary *params = message.body[@"params"];
        NSString *successCallBackID = message.body[@"successCallBackID"];
        NSString *failureCallBackID = message.body[@"failureCallBackID"];
        __weak typeof(self) weakSelf = self;
        [self interactWithPlugin:plugin funcName:funcName params:params success:^(id response) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf) {
                [strongSelf _jkCallJSCallBackWithCallBackName:successCallBackID response:response];
            }
            
        } failure:^(id response) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf) {
                [strongSelf _jkCallJSCallBackWithCallBackName:failureCallBackID response:response];}
        }];
        
    }
    
}

- (void)interactWithPlugin:(NSString *)plugin funcName:(NSString *)funcName params:(NSDictionary *)params success:(void(^)(id response))successCallBack failure:(void(^)(id response))failureCallBack{
    funcName = [NSString stringWithFormat:@"%@:::",funcName];
    SEL selector =NSSelectorFromString(funcName);
    if ([NSClassFromString(plugin) respondsToSelector:selector]) {
        id parameter = nil;
        if (params) {
            parameter = params;
        }else{
            parameter = [JKEventHandlerEmptyObject class];
        }
        
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
        NSArray *paramArray =@[parameter,successBlock,failureBlock];
        [self class:NSClassFromString(plugin) performSelector:selector withObjects:paramArray];
    }else{
        if (failureCallBack) {
            NSError *error = [[NSError alloc] initWithDomain:@"JKEventHandler" code:-10000 userInfo:@{@"msg":[NSString stringWithFormat:@"%@ unsupport %@",plugin,funcName]}];
            failureCallBack(error);
        }
    }
    
}

- (void)class:(Class)class performSelector:(SEL)aSelector withObjects:(NSArray *)objects {
    NSMethodSignature *signature = [NSMethodSignature signatureWithObjCTypes:"v@:@@@"];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:class];
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
    
}

- (void)_jkCallJSCallBackWithCallBackName:(NSString *)callBackName response:(id)response{
    WKWebView *weakWebView = _webView;
    if ([response isKindOfClass:[NSDictionary class]] || [response isKindOfClass:[NSMutableDictionary class]] || [response isKindOfClass:[NSArray class]] || [response isKindOfClass:[NSMutableArray class]]) {
        NSData *data=[NSJSONSerialization dataWithJSONObject:response options:NSJSONWritingPrettyPrinted error:nil];
        
        NSString *jsonStr=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
         jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        response = jsonStr;
    }
    NSString *js = [NSString stringWithFormat:@"JKEventHandler.callBack('%@','%@');",callBackName,response];
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakWebView evaluateJavaScript:js completionHandler:^(id _Nullable data, NSError * _Nullable error) {
            JKEventHandlerLog(@"JKEventHandler.callBack: %@\n response: %@",callBackName,response);
        }];
    });
}

- (void)evaluateJavaScript:(NSString *)js completed:(void(^)(id data, NSError *error))completed{
    [self.webView evaluateJavaScript:js completionHandler:^(id _Nullable data, NSError * _Nullable error) {
        if (completed) {
            completed(data,error);
        }
    }];
}

- (id)synEvaluateJavaScript:(NSString *)js error:(NSError **)error
{
   __block id result = nil;
    __block BOOL success = NO;
    __block NSError *resultError = nil;
    [self.webView evaluateJavaScript:js completionHandler:^(id tmpResult, NSError * _Nullable tmpError) {
        if (!tmpError) {
            result = tmpResult;
            success = YES;
        } else {
            resultError = tmpError;
        }
        success = YES;
    }];
    
    while (!success) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    if (error != NULL) {
        *error = resultError;
    }
    return result;
}

@end

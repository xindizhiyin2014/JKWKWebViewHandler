//
//  JKEventHandler.m
//  Pods
//
//  Created by Jack on 17/3/31.
//
//

#import "JKEventHandler.h"
#import <JKDataHelper/JKDataHelper.h>
#ifdef DEBUG
#define JKEventHandlerLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define JKEventHandlerLog(...)
#endif

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
        NSString *plugin = [message.body jk_stringForKey:@"plugin"];
        NSString *funcName = [message.body jk_stringForKey:@"func"];
        NSDictionary *params = [message.body jk_dictionaryForKey:@"params"];
        NSString *successCallBackID = [message.body jk_stringForKey:@"successCallBackID"];
        NSString *failureCallBackID = [message.body jk_stringForKey:@"failureCallBackID"];
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

- (void)interactWithPlugin:(NSString *)plugin
                  funcName:(NSString *)funcName
                    params:(NSDictionary *)params
                   success:(void(^)(id response))successCallBack
                   failure:(void(^)(id response))failureCallBack{
    funcName = [NSString stringWithFormat:@"%@:::",funcName];
    SEL selector =NSSelectorFromString(funcName);
    Class realHandler = NSClassFromString(plugin);
    if ([realHandler respondsToSelector:selector]) {
        IMP imp = [realHandler methodForSelector:selector];
        void (*func)(id, SEL, id, id, id) = (void *)imp;
        func(realHandler, selector, params, successCallBack,failureCallBack);
    }else{
        if (failureCallBack) {
            NSError *error = [[NSError alloc] initWithDomain:@"JKEventHandler" code:-10000 userInfo:@{@"msg":[NSString stringWithFormat:@"%@ unsupport %@",plugin,funcName]}];
            failureCallBack(error);
        }
    }
}

- (void)_jkCallJSCallBackWithCallBackName:(NSString *)callBackName response:(id)response{
    WKWebView *weakWebView = _webView;
    if ([response isKindOfClass:[NSDictionary class]]
        || [response isKindOfClass:[NSArray class]]) {
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

- (void)evaluateJavaScript:(NSString *)js
                 completed:(void(^)(id data, NSError *error))completed{
    [self.webView evaluateJavaScript:js completionHandler:^(id _Nullable data, NSError * _Nullable error) {
        if (completed) {
            completed(data,error);
        }
    }];
}

- (id)synEvaluateJavaScript:(NSString *)js
                      error:(NSError **)error
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

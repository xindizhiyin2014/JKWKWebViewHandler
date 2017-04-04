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

 const NSString *EventHandler = @"JKEventHandler";
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
    if ([message.name isEqualToString:EventHandler]) {
        
        NSString *methodName = message.body[@"methodName"];
        NSDictionary *params = message.body[@"params"];
        NSString *callBackName = message.body[@"callBackName"];
        if (callBackName) {
            
            __weak  WKWebView *weakWebView = _webView;
            [self interactWitMethodName:methodName params:params :^(id response) {
                
                NSString *js = [NSString stringWithFormat:@"JKEventHandler.callBack('%@',%@);",callBackName,response];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakWebView evaluateJavaScript:js completionHandler:^(id _Nullable data, NSError * _Nullable error) {
                        
                        NSLog(@"mmmmmmmmmmmmmmm");
                        
                    }];
                });
                
                
            }];
        }else{
            
            [self interactWitMethodName:methodName params:params :nil];
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
                [self JKperformSelector:selector withObjects:paramArray];
            }
        }else{
            SEL selector =NSSelectorFromString(methodName);
            NSArray *paramArray =@[params];
            if ([self respondsToSelector:selector]) {
                [self JKperformSelector:selector withObjects:paramArray];
            }

        }
    }else{
        
        if (callBack) {
            methodName = [NSString stringWithFormat:@"%@:",methodName];
            SEL selector =NSSelectorFromString(methodName);
            NSArray *paramArray =@[callBack];
            if ([self respondsToSelector:selector]) {
                [self JKperformSelector:selector withObjects:paramArray];
            }
        }else{
            SEL selector =NSSelectorFromString(methodName);
            
            if ([self respondsToSelector:selector]) {
                [self JKperformSelector:selector withObjects:nil];
            }
            
        }
    
    }
}

- (id)JKperformSelector:(SEL)aSelector withObjects:(NSArray *)objects {
    NSMethodSignature *signature = [self methodSignatureForSelector:aSelector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:self];
    [invocation setSelector:aSelector];
    
    NSUInteger i = 1;
    
    for (id object in objects) {
        id tempObject = object;
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




@end

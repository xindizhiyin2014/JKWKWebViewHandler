//
//  JKPluginA.m
//  JKWKWebViewHandler_Example
//
//  Created by JackLee on 2019/7/21.
//  Copyright © 2019 HHL110120. All rights reserved.
//

#import "JKPluginA.h"

@implementation JKPluginA
+ (void)getNativeInfo:(NSDictionary *)params :(void(^)(id response))successCallBack :(void(^)(id response))failureCallBack{
    NSLog(@"getNativeInfo %@",params);
    if (successCallBack) {
        successCallBack(@"success !!!");
    }
    if (failureCallBack) {
        failureCallBack(@"failure !!!");
    }
}
@end

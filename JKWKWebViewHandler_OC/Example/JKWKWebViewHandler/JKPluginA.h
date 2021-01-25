//
//  JKPluginA.h
//  JKWKWebViewHandler_Example
//
//  Created by JackLee on 2019/7/21.
//  Copyright © 2019 HHL110120. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JKPluginA : NSObject
+ (void)getNativeInfo:(NSDictionary *)params :(void(^)(id response))successCallBack :(void(^)(id response))failureCallBack;
@end

NS_ASSUME_NONNULL_END

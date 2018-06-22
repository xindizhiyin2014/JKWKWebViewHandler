//
//  JKEventHandler+Demo.m
//  JKWKWebViewHandler
//
//  Created by Jack on 17/4/1.
//  Copyright © 2017年 HHL110120. All rights reserved.
//

#import "JKEventHandler+Demo.h"

@implementation JKEventHandler (Demo)

- (void)sendInfoToNative:(id)params{
    NSLog(@"sendInfoToNative :%@",params);
}

- (void)getInfoFromNative:(id)params :(void(^)(id response))callBack{
    NSLog(@"params %@",params);
    NSString *str = @"Hi Jack!";
    NSString *jsonStr = @"{\"name\":\"张三\"}";
    NSDictionary *dic = @{@"name":@"张三"};
    NSArray *arr = @[@"111",@"222"];
    NSString *arrStr = @"[\"111\",\"222\"]";
    if(callBack){
        callBack(arrStr);
    }
    

}

- (void)newGetInfoFromNative:(id)params :(void(^)(id response))successCallBack :(void(^)(id response))failureCallBack{
    NSLog(@"newGetInfoFromNative %@",params);
    if (successCallBack) {
        successCallBack(@"success !!!");
    }
    if (failureCallBack) {
        failureCallBack(@"failure !!!");
    }
}
@end

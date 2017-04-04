//
//  JKEventHandler+Demo.h
//  JKWKWebViewHandler
//
//  Created by Jack on 17/4/1.
//  Copyright © 2017年 HHL110120. All rights reserved.
//

#import <JKWKWebViewHandler/JKWKWebViewHandler.h>

@interface JKEventHandler (Demo)

- (void)sendInfoToNative:(id)params;

- (void)getInfoFromNative:(id)params :(void(^)(id response))callBack;

@end

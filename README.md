# JKWKWebViewHandler

[![CI Status](http://img.shields.io/travis/HHL110120/JKWKWebViewHandler.svg?style=flat)](https://travis-ci.org/HHL110120/JKWKWebViewHandler)
[![Version](https://img.shields.io/cocoapods/v/JKWKWebViewHandler.svg?style=flat)](http://cocoapods.org/pods/JKWKWebViewHandler)
[![License](https://img.shields.io/cocoapods/l/JKWKWebViewHandler.svg?style=flat)](http://cocoapods.org/pods/JKWKWebViewHandler)
[![Platform](https://img.shields.io/cocoapods/p/JKWKWebViewHandler.svg?style=flat)](http://cocoapods.org/pods/JKWKWebViewHandler)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

JKWKWebViewHandler is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "JKWKWebViewHandler"
```

## Author

HHL110120, 929097264@qq.com

## QQ Contact group

if you use QQ you can use this Qrcode to contact with us

![](https://github.com/xindizhiyin2014/JKWKWebViewHandler/blob/master/JKWebViewhandler.png?raw=true)

## developer guide

### step 1 
you should config the JKEventHandler

```
WKUserScript *usrScript = [[WKUserScript alloc] initWithSource:[JKEventHandler shareInstance].handlerJS injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    
    // 通过JS与webview内容交互
    config.userContentController = [[WKUserContentController alloc] init];
    
    [config.userContentController addUserScript:usrScript];
    // 注入JS对象名称AppModel，当JS通过AppModel来调用时，
    // 我们可以在WKScriptMessageHandler代理中接收到
    [config.userContentController addScriptMessageHandler:[JKEventHandler shareInstance] name:EventHandler];
   
    
    
    
    //通过默认的构造器来创建对象
    _webView = [[WKWebView alloc] initWithFrame:self.view.bounds
                                  configuration:config];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
    [self.view addSubview:_webView];

```

### step 2
this is for JS developer
```
callNativeFunction:function(nativeMethodName,params,callBackID,callBack){
 //when you want to call native function ,you should call this function with params.

 //nativeMethodName: this is the functionName of native.

 //params:this is the data you want to send to native.

 //callBackID:this is the callBackIdentifier you should to specified if you need a callBack. you shoud make sure it is unique

 //callBack:this is the content of the callback.

}

```
for Example:
```
JKEventHandler.callNativeFunction('getInfoFromNative',params,'getInfoFromNativeCallback',function(data){
            alert(data);
        });
```

### step 3

this is for native developer
if you want interect with H5,you should create a category  of class JKEventHandler. and create the function the H5 specified to interected with you. for example:

```
#import <JKWKWebViewHandler/JKWKWebViewHandler.h>

@interface JKEventHandler (Demo)

- (void)sendInfoToNative:(id)params;

- (void)getInfoFromNative:(id)params :(void(^)(id response))callBack;

@end


#import "JKEventHandler+Demo.h"

@implementation JKEventHandler (Demo)

- (void)sendInfoToNative:(id)params{
    NSLog(@"sendInfoToNative :%@",params);
}

- (void)getInfoFromNative:(id)params :(void(^)(id response))callBack{
    NSLog(@"params %@",params);
    NSString *str = @"'Hi Jack!'";
    callBack(str);

}
@end
```


## License

JKWKWebViewHandler is available under the MIT license. See the LICENSE file for more info.

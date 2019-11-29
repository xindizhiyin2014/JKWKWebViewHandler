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
exec:function(plugin,funcName,params,successCallBack,failureCallBack){
 //when you want to call native function ,you should call this function with params.
 //plugin:the native className to handle the js func
 //funcName:the native funcName
 
 //params:this is the data you want to send to native.

 //successCallBack:this is the success block

 //failureCallBack:this is  the failure block

}

```
for Example:
```
function getInfoFromNative(){
var params = {'name':'我是jack！！！'};
JKEventHandler.exec('JKPluginA','getNativeInfo',params,function(data){
console.log('succedss block');
alert(data);
},
function(data){
console.log('fail block');
alert(data);
});
}
```

### step 3

this is for native developer
if you want interect with H5,you should create a plugin  class  and create the function the H5 specified to interected with you. for example:

```
#import <Foundation/Foundation.h>

@interface JKPluginA : NSObject
+ (void)getNativeInfo:(NSDictionary *)params :(void(^)(id response))successCallBack :(void(^)(id response))failureCallBack;
@end


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
```


## License

JKWKWebViewHandler is available under the MIT license. See the LICENSE file for more info.

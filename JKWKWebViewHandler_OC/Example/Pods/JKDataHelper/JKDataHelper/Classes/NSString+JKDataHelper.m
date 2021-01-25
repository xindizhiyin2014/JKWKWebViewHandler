//
//  NSString+JKDataHelper.m
//  JKDataHelper
//
//  Created by JackLee on 2018/11/9.
//

#import "NSString+JKDataHelper.h"

@implementation NSString (JKDataHelper)
- (NSString *)jk_trimWhiteSpace{
    
  return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)jk_trimWhiteSpaceAndNewLine{
  return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

//将url ？后的字符串转换为NSDictionary对象
- (NSMutableDictionary *)jk_urlStringConvertToDictionary{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSArray *parameterArr = [self componentsSeparatedByString:@"&"];
    for (NSString *parameter in parameterArr) {
        NSArray *parameterBoby = [parameter componentsSeparatedByString:@"="];
        if (parameterBoby.count == 2) {
            [dic setObject:parameterBoby[1] forKey:parameterBoby[0]];
        }else
        {
            return nil;
        }
    }
    return dic;
}
@end

#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "JKDataHelper.h"
#import "NSArray+JKDataHelper.h"
#import "NSDictionary+JKDataHelper.h"
#import "NSString+JKDataHelper.h"

FOUNDATION_EXPORT double JKDataHelperVersionNumber;
FOUNDATION_EXPORT const unsigned char JKDataHelperVersionString[];


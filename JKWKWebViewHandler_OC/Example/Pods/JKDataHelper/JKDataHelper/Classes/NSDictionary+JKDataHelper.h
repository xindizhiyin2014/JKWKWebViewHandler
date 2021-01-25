//
//  NSDictionary+JKDataHelper.h
//  Pods
//
//  Created by Jack on 17/3/28.
//
//

#import <Foundation/Foundation.h>

@interface NSDictionary<__covariant KeyType, __covariant ObjectType> (JKDataHelper)

- (BOOL)jk_hasKey:(nullable NSString *)key;

/// 根据key获取元素值，并对元素类型进行判断
/// @param key key
/// @param theClass 进行判定的类
- (nullable ObjectType)jk_objectForKey:(nullable NSString *)key
                          verifyClass:(nullable Class)theClass;

- (nullable NSString*)jk_stringForKey:(nonnull NSString *)key;

- (nullable NSNumber*)jk_numberForKey:(nonnull NSString *)key;

- (nullable NSDecimalNumber *)jk_decimalNumberForKey:(nonnull NSString *)key;

- (nullable NSArray*)jk_arrayForKey:(nonnull NSString *)key;

- (nullable NSDictionary*)jk_dictionaryForKey:(nonnull NSString *)key;

- (NSInteger)jk_integerForKey:(nonnull NSString *)key;

- (NSUInteger)jk_unsignedIntegerForKey:(nonnull NSString *)key;

- (BOOL)jk_boolForKey:(nonnull NSString *)key;

- (int16_t)jk_int16ForKey:(nonnull NSString *)key;

- (int32_t)jk_int32ForKey:(nonnull NSString *)key;

- (int64_t)jk_int64ForKey:(nonnull NSString *)key;

- (char)jk_charForKey:(nonnull NSString *)key;

- (short)jk_shortForKey:(nonnull NSString *)key;

- (float)jk_floatForKey:(nonnull NSString *)key;

- (CGFloat)jk_cgFloatForKey:(nonnull NSString *)key;

- (double)jk_doubleForKey:(nonnull NSString *)key;

- (long long)jk_longLongForKey:(nonnull NSString *)key;

- (unsigned long long)jk_unsignedLongLongForKey:(nonnull NSString *)key;

- (nullable NSDate *)jk_dateForKey:(nonnull NSString *)key
                        dateFormat:(nonnull NSString *)dateFormat;

- (CGPoint)jk_pointForKey:(nonnull NSString *)key;

- (CGSize)jk_sizeForKey:(nonnull NSString *)key;

- (CGRect)jk_rectForKey:(nonnull NSString *)key;

-  (nullable NSDictionary *)jk_dictionaryForKeyPath:(nonnull NSString *)keyPath;

- (nullable NSArray *)jk_arrayForKeyPath:(nonnull NSString *)keyPath;

- (nullable NSString *)jk_stringForKeyPath:(nonnull NSString *)keyPath;

- (nullable NSNumber *)jk_numberForKeyPath:(nonnull NSString *)keyPath;

- (NSInteger)jk_integerForKeyPath:(nonnull NSString *)keyPath;

/// 存在精度问题，可以通过限定位数，NSDecimalNumber 实现更高的精度
/// @param keyPath keyPath
- (CGFloat)jk_cgFloatForKeyPath:(nonnull NSString *)keyPath;

/// 存在精度问题，可以通过限定位数，NSDecimalNumber 实现更高的精度
/// @param keyPath keyPath
- (float)jk_floatForKeyPath:(nonnull NSString *)keyPath;

/// 存在精度问题，可以通过限定位数，NSDecimalNumber 实现更高的精度
/// @param keyPath keyPath
- (double)jk_doubleForKeyPath:(nonnull NSString *)keyPath;

- (BOOL)jk_boolForKeyPath:(nonnull NSString *)keyPath;

@end

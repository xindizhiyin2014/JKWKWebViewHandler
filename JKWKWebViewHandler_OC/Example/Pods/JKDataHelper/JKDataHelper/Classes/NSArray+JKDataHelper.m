//
//  NSArray+JKDataHelper.m
//  Pods
//
//  Created by Jack on 17/3/28.
//
//

#import "NSArray+JKDataHelper.h"

@implementation NSArray (JKDataHelper)

- (nullable id)jk_objectWithIndex:(NSInteger)index
{
    
    if (index < 0) {
        return nil;
    }
    if (index < self.count) {
        return self[index];
    }
    return nil;
}

- (nullable id)jk_objectWithIndex:(NSInteger)index
                      verifyClass:(nullable Class)theClass
{
    if (!theClass) {
        return [self jk_objectWithIndex:index];
    }
 if (![theClass isSubclassOfClass:[NSObject class]]) {
#if DEBUG
        NSAssert(NO, @"theClass must be subClass of NSObject");
#endif
        return nil;
    }
    id object = [self jk_objectWithIndex:index];
    if ([object isKindOfClass: theClass]) {
        return object;
    }
    return nil;
}

- (nullable NSString*)jk_stringWithIndex:(NSInteger)index
{
    
    id value = [self jk_objectWithIndex:index];
    if (value == nil || value == [NSNull null])
    {
        return nil;
    }
    if ([value isKindOfClass:[NSString class]]) {
        return (NSString*)value;
    }
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value stringValue];
    }
    return nil;
}

- (nullable NSNumber*)jk_numberWithIndex:(NSInteger)index{
    
    id value = [self jk_objectWithIndex:index];
    if ([value isKindOfClass:[NSNumber class]]) {
        return (NSNumber*)value;
    }
    if ([value isKindOfClass:[NSString class]]) {
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        return [f numberFromString:(NSString*)value];
    }
    return nil;
}

- (nullable NSDecimalNumber *)jk_decimalNumberWithIndex:(NSInteger)index{
    
    id value = [self jk_objectWithIndex:index];
    if ([value isKindOfClass:[NSDecimalNumber class]]) {
        return value;
    }
    if ([value isKindOfClass:[NSNumber class]]) {
        NSNumber * number = (NSNumber*)value;
        return [NSDecimalNumber decimalNumberWithDecimal:[number decimalValue]];
    }
    if ([value isKindOfClass:[NSString class]]) {
        NSString * str = (NSString*)value;
        return [str isEqualToString:@""] ? nil : [NSDecimalNumber decimalNumberWithString:str];
    }
    return nil;
}

- (nullable NSArray*)jk_arrayWithIndex:(NSInteger)index{
    
    id value = [self jk_objectWithIndex:index];
    if (value == nil || value == [NSNull null])
    {
        return nil;
    }
    if ([value isKindOfClass:[NSArray class]])
    {
        return value;
    }
    return nil;
}

- (nullable NSDictionary*)jk_dictionaryWithIndex:(NSInteger)index{
    
    id value = [self jk_objectWithIndex:index];
    if (value == nil || value == [NSNull null])
    {
        return nil;
    }
    if ([value isKindOfClass:[NSDictionary class]])
    {
        return value;
    }
    return nil;
}

- (NSInteger)jk_integerWithIndex:(NSInteger)index{
    
    id value = [self jk_objectWithIndex:index];
    if (value == nil || value == [NSNull null])
    {
        return 0;
    }
    if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]])
    {
        return [value integerValue];
    }
    return 0;
}

- (NSUInteger)jk_unsignedIntegerWithIndex:(NSInteger)index{
    
    id value = [self jk_objectWithIndex:index];
    if (value == nil || value == [NSNull null])
    {
        return 0;
    }
    if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]])
    {
        return [value unsignedIntegerValue];
    }
    return 0;
}

- (BOOL)jk_boolWithIndex:(NSInteger)index
{
    id value = [self jk_objectWithIndex:index];
    if (value == nil || value == [NSNull null])
    {
        return NO;
    }
    if ([value isKindOfClass:[NSNumber class]])
    {
        return [value boolValue];
    }
    if ([value isKindOfClass:[NSString class]])
    {
        return [value boolValue];
    }
    return NO;
}

- (int16_t)jk_int16WithIndex:(NSInteger)index
{
    id value = [self jk_objectWithIndex:index];
    if (value == nil || value == [NSNull null])
    {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]])
    {
        return [value shortValue];
    }
    if ([value isKindOfClass:[NSString class]])
    {
        return [value intValue];
    }
    return 0;
}

- (int32_t)jk_int32WithIndex:(NSInteger)index
{
    id value = [self jk_objectWithIndex:index];
    if (value == nil || value == [NSNull null])
    {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]])
    {
        return [value intValue];
    }
    return 0;
}

- (int64_t)jk_int64WithIndex:(NSInteger)index
{
    id value = [self jk_objectWithIndex:index];
    if (value == nil || value == [NSNull null])
    {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]])
    {
        return [value longLongValue];
    }
    return 0;
}

- (char)jk_charWithIndex:(NSInteger)index{
    
    id value = [self jk_objectWithIndex:index];
    if (value == nil || value == [NSNull null])
    {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]])
    {
        return [value charValue];
    }
    return 0;
}

- (short)jk_shortWithIndex:(NSInteger)index{
    
    id value = [self jk_objectWithIndex:index];
    if (value == nil || value == [NSNull null])
    {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]])
    {
        return [value shortValue];
    }
    if ([value isKindOfClass:[NSString class]])
    {
        return [value intValue];
    }
    return 0;
}
- (float)jk_floatWithIndex:(NSInteger)index{
    
    id value = [self jk_objectWithIndex:index];
    if (value == nil || value == [NSNull null])
    {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]])
    {
        return [value floatValue];
    }
    return 0;
}

- (CGFloat)jk_cgFloatWithIndex:(NSInteger)index{
    CGFloat value = (CGFloat)[self jk_floatWithIndex:index];
    return value;
}

- (double)jk_doubleWithIndex:(NSInteger)index
{
    id value = [self jk_objectWithIndex:index];
    
    if (value == nil || value == [NSNull null])
    {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]])
    {
        return [value doubleValue];
    }
    return 0;
}

- (nullable NSDate *)jk_dateWithIndex:(NSInteger)index
                           dateFormat:(nonnull NSString *)dateFormat {
    
    id value = [self jk_objectWithIndex:index];
    if (value == nil || value == [NSNull null])
    {
        return nil;
    }
    if ([value isKindOfClass:[NSString class]] && ![value isEqualToString:@""] && !dateFormat) {
        NSDateFormatter *formater = [[NSDateFormatter alloc]init];
        formater.dateFormat = dateFormat;
        return [formater dateFromString:value];
    }
    return nil;
}

- (nonnull NSMutableArray *)jk_valueArrayWithKey:(nonnull NSString *)key
{
    if (!key) {
#if DEBUG
        NSAssert(NO, @"key can not be nil");
#endif
        return nil;
    }
    NSMutableArray *values = [NSMutableArray new];
    for (NSObject *obj in self) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = (NSDictionary *)obj;
            id value = [dic objectForKey:key];
            if (value) {
                [values addObject:value];
            }
        } else {
            SEL selector = NSSelectorFromString(key);
            if ([obj respondsToSelector:selector]) {
                id value = [obj valueForKey:key];
                if (value) {
                    [values addObject:value];
                }
            }
        }
    }
    return values;
}

- (nonnull NSArray *)jk_uniqueValuesWithKey:(nonnull NSString *)key
{
    if (!key) {
#if DEBUG
        NSAssert(NO, @"key can't be nil");
#endif
        return nil;
    }
    NSMutableSet *set = [NSMutableSet new];
    for (NSObject *obj in self) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = (NSDictionary *)obj;
            id value = [dic objectForKey:key];
            if (value) {
                [set addObject:value];
            }
        } else {
            SEL selector = NSSelectorFromString(key);
            if ([obj respondsToSelector:selector]) {
                id value = [obj valueForKey:key];
                if (value) {
                    [set addObject:value];
                }
            }
        }
        
    }
    return [set allObjects];
}

- (nonnull NSMutableArray *)jk_ascSort{
    NSMutableArray *array = (NSMutableArray *)self;
    if (![self isKindOfClass:[NSMutableArray class]]) {
        array = [NSMutableArray arrayWithArray:self];
    }
    [array sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 integerValue] > [obj2 integerValue];
    }];
    return array;
}

- (nonnull NSMutableArray *)jk_descSort{
    NSMutableArray *array = (NSMutableArray *)self;
    if (![self isKindOfClass:[NSMutableArray class]]) {
        array = [NSMutableArray arrayWithArray:self];
    }
    [array sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 integerValue] < [obj2 integerValue];
    }];
    return array;
}

- (CGPoint)jk_pointWithIndex:(NSInteger)index{
    
    id value = [self jk_objectWithIndex:index];
    CGPoint point = CGPointFromString(value);
    return point;
}

- (CGSize)jk_sizeWithIndex:(NSInteger)index{
    
    id value = [self jk_objectWithIndex:index];
    CGSize size = CGSizeFromString(value);
    return size;
}

- (CGRect)jk_rectWithIndex:(NSInteger)index{
    
    id value = [self jk_objectWithIndex:index];
    CGRect rect = CGRectFromString(value);
    return rect;
}


@end

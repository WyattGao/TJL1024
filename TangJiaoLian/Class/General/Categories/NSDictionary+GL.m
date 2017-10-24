//
//  NSDictionary+GL.m
//  TangJiaoLian
//
//  Created by 高临原 on 2017/3/20.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "NSDictionary+GL.h"

@implementation NSDictionary (GL)

- (NSString *)getStringValue:(id)key
{
    if ([self objectForKey:key] == nil || [[self objectForKey:key] isEqual:[NSNull null]]) {
        return @"";
    }
    
    if ([[self objectForKey:key]respondsToSelector:@selector(stringValue)]) {
        return [[self objectForKey:key] stringValue];
    }
    
    
    return [self objectForKey:key];
}

- (NSInteger)getIntegerValue:(id)key
{
    if ([self objectForKey:key] == nil || [[self objectForKey:key] isEqual:[NSNull null]]) {
        return 0;
    }
    return [[self objectForKey:key] integerValue];
}

- (double)getDoubleValue:(id)key
{
    if ([self objectForKey:key] == nil || [[self objectForKey:key] isEqual:[NSNull null]]) {
        return 0;
    }
    return [[self objectForKey:key] doubleValue];
}

- (CGFloat)getFloatValue:(id)key
{
    if ([self objectForKey:key] == nil || [[self objectForKey:key] isEqual:[NSNull null]]) {
        return 0;
    }
    
    return [[self objectForKey:key] floatValue];
}

- (NSArray *)getArrValue:(id)key
{
    if ([self objectForKey:key] == nil || [[self objectForKey:key] isEqual:[NSNull null]]) {
        return @[];
    }
    return [self objectForKey:key];
}

- (NSDictionary *)getDictionaryValue:(id)key
{
    if ([self objectForKey:key] == nil || [[self objectForKey:key] isEqual:[NSNull null]]) {
        return @{};
    }
    return [self objectForKey:key];
}

- (NSString *)descriptionWithLocale:(id)locale
{
    NSMutableString * str = [NSMutableString new];
    [str appendString:@"(\n"];
    for (NSString * key in self.allKeys) {
        [str appendFormat:@"\t%@ = \"%@\";\n", key, self[key]];
    }
    [str appendString:@")"];
    return str;
}

@end

//
//  NSUserDefaults+GL.m
//  TangJiaoLian
//
//  Created by 高临原 on 2017/3/19.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "NSUserDefaults+GL.h"

@implementation NSUserDefaults (GL)

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


@end

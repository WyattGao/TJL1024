//
//  GLEntity.m
//  TangJiaoLian
//
//  Created by 高临原 on 2017/3/15.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "GLEntity.h"
#import <objc/runtime.h>

@implementation GLEntity

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        for (NSString * entry in dict.allKeys) {
            id val = [dict valueForKey:entry];
            if (!val || [val isKindOfClass:[NSNull class]]) { continue; }
            @try {
                [self setValue:val forKeyPath:entry];
            }
            @catch (NSException *exception) {
                
            }
            @finally {
                
            }
        }
    }
    return self;
}

/* 获取对象的所有属性的数组 */
- (NSArray *)getAllProperties
{
    u_int count;
    
    objc_property_t *properties  =class_copyPropertyList([self class], &count);
    
    NSMutableArray *propertiesArray = [NSMutableArray arrayWithCapacity:count];
    
    for (int i = 0; i < count ; i++)
    {
        const char* propertyName =property_getName(properties[i]);
        [propertiesArray addObject: [NSString stringWithUTF8String: propertyName]];
    }
    
    free(properties);
    
    return propertiesArray;
}

/* 获取对象的所有属性和属性内容的字典 */
- (NSDictionary *)getAllPropertiesAndVaules
{
    NSMutableDictionary *props = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    objc_property_t *properties =class_copyPropertyList([self class], &outCount);
    for (i = 0; i<outCount; i++)
    {
        objc_property_t property = properties[i];
        const char* char_f =property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        id propertyValue = [self valueForKey:(NSString *)propertyName];
        if (propertyValue) [props setObject:propertyValue forKey:propertyName];
    }
    free(properties);
    return props;
}


@end

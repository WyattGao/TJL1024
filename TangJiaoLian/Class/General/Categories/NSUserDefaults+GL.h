//
//  NSUserDefaults+GL.h
//  TangJiaoLian
//
//  Created by 高临原 on 2017/3/19.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (GL)

/**
 * @brief 根据键获取一个字符串,如果不存在键活着为NSNull类型将返回一个空字符串
 */
- (NSString *)getStringValue:(id)key;
/**
 * @brief 根据键获取一个整型值,如果不存在或者为NSNull返回0
 */
- (NSInteger)getIntegerValue:(id)key;
/**
 * @brief 根据键获取一个Double值,如果不存在键或者为NSNull返回0
 */
- (double)getDoubleValue:(id)key;
/**
 * @brief 根据键获取一个Float值,如果不存在键或者为NSNull返回0
 */
- (CGFloat)getFloatValue:(id)key;

@end

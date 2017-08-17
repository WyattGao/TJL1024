//
//  GLCache.h
//  TangJiaoLian
//
//  Created by 高临原 on 2017/3/20.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLCache : NSDate


/**
 数组写缓存

 @param arr  数组
 @param name 缓存名称
 */
+ (void)writeCacheArr:(NSArray *)arr name:(NSString *)name;



/**
 读取数组缓存

 @param name 缓存名称
 @return 数组
 */
+ (NSArray *)readCacheArrWithName:(NSString *)name;

@end

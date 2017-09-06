//
//  NSDate+GL.h
//  TangJiaoLian
//
//  Created by 高临原 on 2017/3/19.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (GL)

- (NSString *)toString:(NSString *)format;

- (NSString *)toStringyyyyMMddHHmmss;

+ (NSDate *)dateWithTimeIntervalInMilliSecondSince1970:(double)timeIntervalInMilliSecond;

+ (NSString *)nowDateString;


/**
 根据日期对象获取星期几的字符串

 @return 返回星期几的字符串
 */
- (NSString *)toWeekString;

@end

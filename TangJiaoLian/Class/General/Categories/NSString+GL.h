//
//  NSString+GL.h
//  TangJiaoLian
//
//  Created by 高临原 on 2017/3/20.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (GL)


/**
 将字符串转换为时间对象

 @param formatStr 字符串的时间格式
 @return 转换好的时间对象
 */
- (NSDate *)toDate:(NSString *)formatStr;


/**
 通过默认格式转换字符串为时间对象

 @return 转换后的时间对象
 */
- (NSDate *)toDateDefault;

/**
 * @brief MD5加密
 */
+ (id)MD5EncryptionWithString:(NSString *)str;

/**
 * @brief MD5加密
 */
- (NSString *)toMD5Encryption;

/**
 *  登陆密码加密
 *
 *  @return 加密后的登录密码
 */
- (NSString *)md5HexDigest;

@end

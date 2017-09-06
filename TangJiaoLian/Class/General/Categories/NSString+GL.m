//
//  NSString+GL.m
//  TangJiaoLian
//
//  Created by 高临原 on 2017/3/20.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "NSString+GL.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation NSString (GL)

- (NSDate *)toDate:(NSString *)formatStr
{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:formatStr];
    NSDate *date = [dateFormatter dateFromString:self];
    return date;
}

- (NSDate *)toDateDefault
{
    return [self toDate:@"yyyy-MM-dd HH:mm:ss"];
}

+ (id)MD5EncryptionWithString:(NSString *)str
{
    if (str == nil) {
        return nil;
    }
    const char *cStr = [str UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (int)str.length, digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    
    return result;
}

- (NSString *)toMD5Encryption
{
    return [NSString MD5EncryptionWithString:self];
}

- (NSString *)md5HexDigest
{
    const char * str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    CC_MD5(str, strlen(str), result);
    for (int j=0; j<CC_MD5_DIGEST_LENGTH; j++) {
        [ret appendFormat:@"%d",result[j]&0x11];
    }
    return ret;
}

@end

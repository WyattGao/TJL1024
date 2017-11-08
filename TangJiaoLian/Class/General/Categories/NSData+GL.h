//
//  NSData+GL.h
//  TangJiaoLian
//
//  Created by 高临原 on 2017/11/3.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (GL)

+ (NSData *)compressImage:(UIImage *)image toByte:(NSUInteger)maxLength;

@end
